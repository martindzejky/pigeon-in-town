extends CanvasLayer

const LOCALE_CODES: Array[String] = ['en', 'de', 'sk']
const MUSIC_BUS_NAME := 'music'
const SOUNDS_BUS_NAME := 'sounds'
const FLAG_DIM_COLOR := Color(0.72, 0.72, 0.72, 1.0)
const FLAG_SELECTED_COLOR := Color(1.0, 1.0, 1.0, 1.0)
const FLAG_HOVER_COLOR := Color(1.18, 1.18, 1.18, 1.0)

@export var english_button: TextureButton
@export var german_button: TextureButton
@export var slovak_button: TextureButton
@export var music_slider: HSlider
@export var sounds_slider: HSlider
@export var close_button: Button
@export var close_focus: Control

var _is_open: bool = false
var _music_bus_index: int = -1
var _sounds_bus_index: int = -1
var _language_buttons: Array[TextureButton] = []


func _ready() -> void:
  visible = false
  _music_bus_index = _get_bus_index(MUSIC_BUS_NAME)
  _sounds_bus_index = _get_bus_index(SOUNDS_BUS_NAME)
  _language_buttons = [english_button, german_button, slovak_button]

  for i in _language_buttons.size():
    var button: TextureButton = _language_buttons[i]
    button.pressed.connect(_on_language_pressed.bind(LOCALE_CODES[i]))
    button.mouse_entered.connect(_refresh_language_button_visuals)
    button.mouse_exited.connect(_refresh_language_button_visuals)
    button.focus_entered.connect(_refresh_language_button_visuals)
    button.focus_exited.connect(_refresh_language_button_visuals)

  music_slider.value_changed.connect(_on_music_slider_value_changed)
  sounds_slider.value_changed.connect(_on_sounds_slider_value_changed)
  close_button.pressed.connect(_on_close_pressed)

  _refresh_audio_sliders()
  _refresh_language_button_visuals()


func _unhandled_input(event: InputEvent) -> void:
  if not _is_open:
    return

  if event.is_action_pressed('pause') or event.is_action_pressed('ui_cancel'):
    _close()
    get_viewport().set_input_as_handled()


func _notification(what: int) -> void:
  if what == NOTIFICATION_TRANSLATION_CHANGED:
    _refresh_language_button_visuals()


func open() -> void:
  _is_open = true
  visible = true
  _refresh_audio_sliders()
  _refresh_language_button_visuals()
  _get_selected_language_button().grab_focus()


func _close() -> void:
  _is_open = false
  visible = false
  if close_focus:
    close_focus.grab_focus()


func _get_bus_index(bus_name: String) -> int:
  var bus_index := AudioServer.get_bus_index(bus_name)
  assert(bus_index != -1, 'Audio bus not found: %s' % bus_name)
  return bus_index


func _refresh_audio_sliders() -> void:
  music_slider.value = AudioServer.get_bus_volume_linear(_music_bus_index)
  sounds_slider.value = AudioServer.get_bus_volume_linear(_sounds_bus_index)


func _refresh_language_button_visuals() -> void:
  var selected_index := _find_locale_index(TranslationServer.get_locale())

  for i in _language_buttons.size():
    var button: TextureButton = _language_buttons[i]
    var color := FLAG_SELECTED_COLOR if i == selected_index else FLAG_DIM_COLOR
    if button.is_hovered() or button.has_focus():
      color = FLAG_HOVER_COLOR
    button.self_modulate = color


func _find_locale_index(current_locale: String) -> int:
  for i in LOCALE_CODES.size():
    if current_locale.begins_with(LOCALE_CODES[i]):
      return i

  return 0


func _get_selected_language_button() -> TextureButton:
  return _language_buttons[_find_locale_index(TranslationServer.get_locale())]


func _on_language_pressed(locale_code: String) -> void:
  TranslationServer.set_locale(locale_code)
  _refresh_language_button_visuals()


func _on_music_slider_value_changed(value: float) -> void:
  AudioServer.set_bus_volume_linear(_music_bus_index, value)


func _on_sounds_slider_value_changed(value: float) -> void:
  AudioServer.set_bus_volume_linear(_sounds_bus_index, value)


func _on_close_pressed() -> void:
  _close()
