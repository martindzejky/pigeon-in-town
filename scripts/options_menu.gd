extends CanvasLayer

const LOCALE_CODES: Array[String] = ['en', 'sk']
const LANGUAGE_NAME_KEYS: Array[String] = [
  'ui.options.language.english',
  'ui.options.language.slovak',
]

@export var language_option: OptionButton
@export var close_button: Button
@export var close_focus: Control

var _is_open: bool = false


func _ready() -> void:
  visible = false
  close_button.pressed.connect(_on_close_pressed)
  language_option.item_selected.connect(_on_language_selected)
  _rebuild_language_options()


func _unhandled_input(event: InputEvent) -> void:
  if not _is_open:
    return

  if event.is_action_pressed('pause') or event.is_action_pressed('ui_cancel'):
    _close()
    get_viewport().set_input_as_handled()


func _notification(what: int) -> void:
  if what == NOTIFICATION_TRANSLATION_CHANGED:
    _rebuild_language_options()


func open() -> void:
  _is_open = true
  visible = true
  _rebuild_language_options()
  language_option.grab_focus()


func _close() -> void:
  _is_open = false
  visible = false
  if close_focus:
    close_focus.grab_focus()


func _rebuild_language_options() -> void:
  var selected_index := _find_locale_index(TranslationServer.get_locale())

  language_option.clear()
  for i in LOCALE_CODES.size():
    language_option.add_item(tr(LANGUAGE_NAME_KEYS[i]))

  language_option.select(selected_index)


func _find_locale_index(current_locale: String) -> int:
  for i in LOCALE_CODES.size():
    if current_locale.begins_with(LOCALE_CODES[i]):
      return i

  return 0


func _on_language_selected(index: int) -> void:
  TranslationServer.set_locale(LOCALE_CODES[index])
  _rebuild_language_options()


func _on_close_pressed() -> void:
  _close()
