shader_type canvas_item;
render_mode blend_mix;

uniform float bright_start : hint_range(0.0, 1.0) = 0.72;
uniform float bright_end : hint_range(0.0, 1.0) = 0.92;
uniform float saturation_start : hint_range(0.0, 1.0) = 0.06;
uniform float saturation_end : hint_range(0.0, 1.0) = 0.18;
uniform float falloff : hint_range(1.0, 8.0) = 1.5;

varying vec4 modulate_color;

void vertex() {
	modulate_color = COLOR;
}

void fragment() {
	vec4 tex_color = texture(TEXTURE, UV);
	float max_channel = max(tex_color.r, max(tex_color.g, tex_color.b));
	float min_channel = min(tex_color.r, min(tex_color.g, tex_color.b));
	float saturation = 0.0;
	if (max_channel > 0.0) {
		saturation = (max_channel - min_channel) / max_channel;
	}

	float luminance = dot(tex_color.rgb, vec3(0.299, 0.587, 0.114));
	float bright_mask = smoothstep(bright_start, bright_end, luminance);
	float desaturated_mask = 1.0 - smoothstep(saturation_start, saturation_end, saturation);
	float white_mask = bright_mask * desaturated_mask;
	white_mask = pow(white_mask, falloff);

	vec3 tinted_rgb = tex_color.rgb * modulate_color.rgb;
	vec3 final_rgb = mix(tex_color.rgb, tinted_rgb, white_mask);

	COLOR = vec4(final_rgb, tex_color.a * modulate_color.a);
}
