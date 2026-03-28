extends Control

@export var start_button: Button


func _ready() -> void:
  start_button.pressed.connect(_on_start_pressed)


func _on_start_pressed() -> void:
  SceneTransition.change_scene('res://scenes/level_select.tscn')
