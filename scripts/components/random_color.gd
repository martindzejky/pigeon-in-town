extends Node

class_name RandomColor

@export var target: Sprite2D
@export var gradient: Gradient


func _ready() -> void:
  target.modulate = gradient.sample(randf())
