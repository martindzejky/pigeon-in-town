extends Control

@export var pigeon_icon: TextureRect
@export var town_icon: TextureRect
@export var town_label: Label
@export var follower: PathFollow2D
@export var scale_root: Node2D
@export var town_squash: Squash
@export var pigeon_squash: Squash

var _flying: bool = false
var _outline_material: Material


func _ready() -> void:
  _outline_material = town_icon.material
  _set_highlight(false)
  town_icon.mouse_entered.connect(_on_town_hovered)
  town_icon.mouse_exited.connect(_on_town_unhovered)
  town_icon.focus_entered.connect(_on_town_hovered)
  town_icon.focus_exited.connect(_on_town_unhovered)
  town_icon.gui_input.connect(_on_town_input)


func _set_highlight(on: bool) -> void:
  town_icon.material = _outline_material if on else null
  town_label.visible = on


func _on_town_hovered() -> void:
  if _flying:
    return
  _set_highlight(true)


func _on_town_unhovered() -> void:
  if _flying:
    return
  _set_highlight(false)


func _on_town_input(event: InputEvent) -> void:
  if _flying:
    return
  if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
    _fly_to_town()


func _fly_to_town() -> void:
  _flying = true
  _set_highlight(true)
  town_squash.squash()

  var tween := create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
  tween.tween_property(follower, 'progress_ratio', 1.0, 3.0)
  await tween.finished

  pigeon_squash.squash()
  town_squash.squash()
  var scale_tween := create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
  scale_tween.tween_property(scale_root, 'scale', Vector2.ZERO, 0.3)
  await scale_tween.finished

  SceneTransition.change_scene('res://scenes/town.tscn')
