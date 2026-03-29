extends CanvasLayer

@export var overlay: ColorRect
@export var panel: PanelContainer
@export var resume_button: Button
@export var exit_button: Button
@export var cards_container: HBoxContainer

@export var card_scene: PackedScene

var _is_open: bool = false
var _cards: Dictionary[String, Node] = { }


func _ready() -> void:
  visible = false
  resume_button.pressed.connect(_on_resume_pressed)
  exit_button.pressed.connect(_on_exit_pressed)
  Achievements.achievement_unlocked.connect(_on_achievement_unlocked)
  _build_cards()


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
  _refresh_cards()
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


func _build_cards() -> void:
  for def: Dictionary in Achievements.DEFINITIONS:
    var card: Node = card_scene.instantiate()
    cards_container.add_child(card)
    card.setup(def['id'], def['art'])
    _cards[def['id']] = card


func _refresh_cards() -> void:
  for card: Node in _cards.values():
    card.refresh()


func _on_achievement_unlocked(ids: Array[String]) -> void:
  _open()
  for id: String in ids:
    Achievements.mark_revealed(id)
    if _cards.has(id):
      _cards[id].play_reveal()
