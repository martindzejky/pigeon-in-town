extends Control

@export var pigeon_icon: TextureRect
@export var town_icon: TextureRect
@export var town_label: Label

var _flying: bool = false


func _ready() -> void:
  town_label.visible = false
  town_icon.mouse_entered.connect(_on_town_hovered)
  town_icon.mouse_exited.connect(_on_town_unhovered)
  town_icon.gui_input.connect(_on_town_input)


func _on_town_hovered() -> void:
  if _flying:
    return
  town_label.visible = true


func _on_town_unhovered() -> void:
  town_label.visible = false


func _on_town_input(event: InputEvent) -> void:
  if _flying:
    return
  if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
    _fly_to_town()


func _fly_to_town() -> void:
  _flying = true
  town_label.visible = true

  var target := town_icon.global_position + town_icon.size * 0.5 - pigeon_icon.size * 0.5
  var tween := create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
  tween.tween_property(pigeon_icon, 'global_position', target, 0.8)
  await tween.finished

  SceneTransition.change_scene('res://scenes/town.tscn')
