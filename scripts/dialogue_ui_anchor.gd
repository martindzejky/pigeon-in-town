extends Node2D

class_name DialogueUiAnchor

signal advanced()
signal choice_selected(index: int)

@export var say_bubble_scene: PackedScene
@export var choice_bubble_scene: PackedScene
@export var choice_button_scene: PackedScene
var _bubble: Control = null
var _showing_choices := false


func show_bubble(text: String) -> void:
  hide_bubble()
  _showing_choices = false
  _bubble = say_bubble_scene.instantiate()
  add_child(_bubble)
  _bubble.get_node('panel/label').text = text


func show_choices(options: Array[String]) -> void:
  hide_bubble()
  _showing_choices = true
  _bubble = choice_bubble_scene.instantiate()
  add_child(_bubble)

  var choices_container := _bubble.get_node('panel/choices') as VBoxContainer
  for i in options.size():
    var button := choice_button_scene.instantiate() as Button
    button.text = options[i]
    button.pressed.connect(_on_choice_pressed.bind(i))
    choices_container.add_child(button)

  choices_container.get_child(0).call_deferred('grab_focus')


func hide_bubble() -> void:
  if _bubble:
    _bubble.queue_free()
    _bubble = null
    _showing_choices = false


func _unhandled_input(event: InputEvent) -> void:
  if not _bubble or _showing_choices:
    return

  if event.is_action_pressed('interact'):
    get_viewport().set_input_as_handled()
    advanced.emit()


func _on_choice_pressed(index: int) -> void:
  choice_selected.emit(index)
