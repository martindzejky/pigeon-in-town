extends Node

class_name RandomAnimationStart

@export var target: AnimationPlayer
@export var animation: String = 'idle'


func _ready() -> void:
  target.play(animation)
  target.seek(randf_range(0.0, target.current_animation_length))
