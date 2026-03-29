extends Control

@export var start_button: Button
@export var exit_button: Button


func _ready() -> void:
  start_button.pressed.connect(_on_start_pressed)
  exit_button.pressed.connect(_on_exit_pressed)

  # stagger the title float animations
  $center/title/animation_2.seek(0.5)
  $center/title/animation_3.seek(1.0)

  Events.main_menu_entered.emit()


func _on_start_pressed() -> void:
  SceneTransition.change_scene('res://scenes/level_select.tscn')


func _on_exit_pressed() -> void:
  get_tree().quit()
