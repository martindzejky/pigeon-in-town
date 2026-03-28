extends HBoxContainer

class_name ChoiceButton

@export var button: Button
@export var indicator: TextureRect


func _ready() -> void:
  indicator.visible = false
  button.focus_entered.connect(_on_focus_changed.bind(true))
  button.focus_exited.connect(_on_focus_changed.bind(false))
  button.mouse_entered.connect(button.grab_focus)


func _on_focus_changed(focused: bool) -> void:
  indicator.visible = focused
