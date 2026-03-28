extends Sprite2D

class_name RandomSprite

## The sprites to randomly select from.
@export var sprites: Array[Texture2D] = []
## If this is set, the shadow will be scaled to match the sprite's width.
@export var update_shadow_scale: Node2D


func _ready() -> void:
  var base_width := texture.get_width() as float if texture else 0.0
  var base_shadow_scale := update_shadow_scale.scale if update_shadow_scale else Vector2.ZERO

  if not sprites.is_empty():
    texture = sprites.pick_random()
  elif hframes > 0:
    frame = randi() % hframes
  elif vframes > 0:
    frame = randi() % vframes

  if update_shadow_scale and texture and base_width > 0.0:
    var ratio := texture.get_width() / base_width
    update_shadow_scale.scale = base_shadow_scale * ratio
