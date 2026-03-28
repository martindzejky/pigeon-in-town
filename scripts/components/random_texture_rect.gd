extends TextureRect

class_name RandomTextureRect

## The textures to randomly select from.
@export var textures: Array[Texture2D] = []


func _ready() -> void:
  if not textures.is_empty():
    texture = textures.pick_random()
