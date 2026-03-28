// based on: https://godotshaders.com/shader/2d-outline-inline/
// draws an outline around a sprite by expanding the quad to make room,
// then checking transparent pixels for nearby opaque pixels using
// 16 radial direction samples. works for solid sprites without holes.

shader_type canvas_item;

uniform vec4 color : source_color = vec4(1.0);
uniform float width : hint_range(0, 10) = 1.0; // outline thickness in screen pixels (scale-independent)

varying vec4 modulate;
varying float scaled_width;

void vertex() {
  // save vertex color before fragment() multiplies it by the texture
  modulate = COLOR;

  // compensate for sprite scale so outline stays consistent in screen pixels.
  // without this, a sprite scaled to 0.3 would shrink the outline to 30%
  float scale = length(MODEL_MATRIX[0].xy);
  scaled_width = width / max(scale, 0.001);

  // expand the quad by scaled_width pixels on each side so the outline
  // has room to render beyond the original texture bounds
  VERTEX += (UV * 2.0 - 1.0) * scaled_width;
}

// checks if any pixel within scaled_width distance is opaque,
// by sampling 16 evenly spaced directions around the current pixel
bool has_opaque_neighbour(vec2 uv, vec2 pixel_size, sampler2D tex) {
  const int NUM_DIRECTIONS = 16;
  for (int i = 0; i < NUM_DIRECTIONS; i++) {
    // spread samples evenly in a circle
    float angle = float(i) * TAU / float(NUM_DIRECTIONS);
    vec2 dir = vec2(cos(angle), sin(angle)) * scaled_width;
    vec2 sample_uv = uv + pixel_size * dir;

    // if the sample is within the texture bounds (clamp == identity)
    // and hits an opaque pixel, then the sprite edge is between
    // this pixel and the sample — we're in the outline zone
    if (sample_uv == clamp(sample_uv, vec2(0.0), vec2(1.0))
        && texture(tex, sample_uv).a > 0.0) {
      return true;
    }
  }

  return false;
}

void fragment() {
  // remap UVs from the expanded quad back to the original texture space.
  // the quad grew in vertex(), but UVs still span [0,1] over the larger area.
  // this computes the new pixel size and shifts UVs so the original texture
  // maps back to [0,1] and the margin area falls outside
  vec2 texture_pixel_size = vec2(1.0) / (vec2(1.0) / TEXTURE_PIXEL_SIZE + vec2(scaled_width * 2.0));
  vec2 uv = (UV - texture_pixel_size * scaled_width) * TEXTURE_PIXEL_SIZE / texture_pixel_size;

  if (uv != clamp(uv, vec2(0.0), vec2(1.0))) {
    // we're in the margin area (outside original texture) — start transparent
    COLOR.a = 0.0;
  } else {
    // we're over the actual sprite — sample normally
    COLOR = texture(TEXTURE, uv) * modulate;
  }

  // if this pixel is transparent but has an opaque neighbour nearby,
  // it's on the edge of the sprite — fill it with the outline color
  if (COLOR.a <= 0.0 && has_opaque_neighbour(uv, TEXTURE_PIXEL_SIZE, TEXTURE)) {
    COLOR = color;
  }
}
