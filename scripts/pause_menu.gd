extends CanvasLayer

@export var overlay: ColorRect
@export var panel: PanelContainer
@export var resume_button: Button
@export var exit_button: Button

var _is_open: bool = false


func _ready() -> void:
  visible = false
  resume_button.pressed.connect(_on_resume_pressed)
  exit_button.pressed.connect(_on_exit_pressed)


func _unhandled_input(event: InputEvent) -> void:
  if event.is_action_pressed('pause'):
    if _is_open:
      _close()
    else:
      _open()
    get_viewport().set_input_as_handled()


func _open() -> void:
  _is_open = true
  visible = true
  get_tree().paused = true
  resume_button.grab_focus()


func _close() -> void:
  _is_open = false
  visible = false
  get_tree().paused = false


func _on_resume_pressed() -> void:
  _close()


func _on_exit_pressed() -> void:
  _close()
  SceneTransition.change_scene('res://scenes/main_menu.tscn')
