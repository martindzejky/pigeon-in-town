extends Node2D

class_name DialogueUiAnchor

signal advanced()
signal choice_selected(index: int)
signal typing_finished()

@export var say_bubble_scene: PackedScene
@export var choice_bubble_scene: PackedScene
@export var choice_button_scene: PackedScene
@export var chars_per_second := 30.0
@export var chars_per_line := 35
@export var enter_duration := 0.15
@export var exit_duration := 0.1

var _bubble: Control = null
var _showing_choices := false
var _choice_buttons: Array[Button] = []
var _tween: Tween = null
var _typing_done := false
var _exiting := false
var _label: Label = null


func show_bubble(text: String) -> void:
  hide_bubble()
  _showing_choices = false
  _typing_done = false
  _exiting = false

  var wrapped := _wrap_text(text, chars_per_line)

  _bubble = say_bubble_scene.instantiate()
  add_child(_bubble)

  _label = (_bubble as SayBubble).label
  _label.text = wrapped
  _label.visible_characters = 0
  _bubble.scale = Vector2.ZERO

  # wait one frame so layout computes the bubble size for pivot
  await get_tree().process_frame
  if not _bubble or _typing_done:
    return

  _bubble.pivot_offset = Vector2(_bubble.size.x / 2.0, _bubble.size.y)

  var type_duration := float(wrapped.length()) / chars_per_second
  _tween = create_tween()
  _tween.tween_property(_bubble, 'scale', Vector2.ONE, enter_duration) \
  .set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
  _tween.tween_property(_label, 'visible_characters', wrapped.length(), type_duration)
  _tween.finished.connect(_on_typing_done)


func show_choices(options: Array[String]) -> void:
  hide_bubble()
  _showing_choices = true
  _bubble = choice_bubble_scene.instantiate()
  add_child(_bubble)

  _choice_buttons.clear()
  var choices_container := (_bubble as ChoiceBubble).choices
  for i in options.size():
    var choice := choice_button_scene.instantiate() as ChoiceButton
    choice.button.text = options[i]
    choice.button.pressed.connect(_on_choice_pressed.bind(i))
    choices_container.add_child(choice)
    _choice_buttons.append(choice.button)

  _choice_buttons[0].call_deferred('grab_focus')


func hide_bubble() -> void:
  _kill_tween()
  if _bubble:
    _bubble.queue_free()
    _bubble = null
    _label = null
    _showing_choices = false
    _choice_buttons.clear()
    _typing_done = false
    _exiting = false


func _unhandled_input(event: InputEvent) -> void:
  if not _bubble or _exiting:
    return

  if _showing_choices:
    _handle_choice_input(event)
    return

  if event.is_action_pressed('interact'):
    get_viewport().set_input_as_handled()
    if not _typing_done:
      _skip_typing()
    else:
      _play_exit()


func _on_typing_done() -> void:
  _typing_done = true
  _tween = null
  (_bubble as SayBubble).button_indicator.visible = true
  typing_finished.emit()


func _skip_typing() -> void:
  _kill_tween()
  _bubble.scale = Vector2.ONE
  _label.visible_characters = -1
  _on_typing_done()


func _play_exit() -> void:
  _exiting = true
  _tween = create_tween()
  _tween.tween_property(_bubble, 'scale', Vector2.ZERO, exit_duration) \
  .set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_BACK)
  _tween.finished.connect(func() -> void: advanced.emit())


func _kill_tween() -> void:
  if _tween and _tween.is_valid():
    _tween.kill()
    _tween = null


func _handle_choice_input(event: InputEvent) -> void:
  var focused := get_viewport().gui_get_focus_owner()
  var idx := _choice_buttons.find(focused)

  if event.is_action_pressed('move_up'):
    get_viewport().set_input_as_handled()
    if idx > 0:
      _choice_buttons[idx - 1].grab_focus()
    elif idx == -1:
      _choice_buttons[0].grab_focus()

  elif event.is_action_pressed('move_down'):
    get_viewport().set_input_as_handled()
    if idx >= 0 and idx < _choice_buttons.size() - 1:
      _choice_buttons[idx + 1].grab_focus()
    elif idx == -1:
      _choice_buttons[0].grab_focus()

  elif event.is_action_pressed('interact'):
    get_viewport().set_input_as_handled()
    if idx >= 0:
      _on_choice_pressed(idx)


func _on_choice_pressed(index: int) -> void:
  choice_selected.emit(index)


func _wrap_text(text: String, max_chars: int) -> String:
  var paragraphs := text.split('\n')
  var wrapped: Array[String] = []

  for paragraph in paragraphs:
    if paragraph.is_empty():
      wrapped.append('')
      continue

    var words := paragraph.split(' ')
    var current_line := ''

    for word in words:
      if current_line.is_empty():
        current_line = word
      elif current_line.length() + 1 + word.length() <= max_chars:
        current_line += ' ' + word
      else:
        wrapped.append(current_line)
        current_line = word

    if not current_line.is_empty():
      wrapped.append(current_line)

  return '\n'.join(wrapped)
