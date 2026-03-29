extends Node

@export var click_player: AudioStreamPlayer
@export var hover_player: AudioStreamPlayer


func _ready() -> void:
  var parent := get_parent() as Control
  assert(parent, 'button_sounds must be a child of a Control')
  parent.mouse_entered.connect(_on_hover)
  parent.focus_entered.connect(_on_hover)
  if parent is BaseButton:
    parent.pressed.connect(_on_pressed)
  else:
    parent.gui_input.connect(_on_gui_input)


func _on_pressed() -> void:
  click_player.play()


func _on_hover() -> void:
  hover_player.play()


func _on_gui_input(event: InputEvent) -> void:
  if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
    click_player.play()
