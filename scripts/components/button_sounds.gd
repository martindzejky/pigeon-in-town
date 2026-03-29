extends Node

@export var click_player: AudioStreamPlayer
@export var hover_player: AudioStreamPlayer


func _ready() -> void:
  var button := get_parent() as BaseButton
  assert(button, 'button_sounds must be a child of a BaseButton')
  button.pressed.connect(_on_pressed)
  button.mouse_entered.connect(_on_hover)
  button.focus_entered.connect(_on_hover)


func _on_pressed() -> void:
  click_player.play()


func _on_hover() -> void:
  hover_player.play()
