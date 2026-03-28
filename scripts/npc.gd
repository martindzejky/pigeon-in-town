extends Node2D

class_name Npc

@export_category('Parts')
@export var flip_node: Node2D
@export var squash: Squash
@export var animation: AnimationPlayer
@export var sprite: Sprite2D
@export var dialogue_walker: DialogueWalker

@export_category('Movement')
## Movement speed in pixels per second.
@export var move_speed: float = 150.0

@export var outline_material: Material
@export var interaction_hint: Control

var _in_dialogue: bool = false


func _enter_tree() -> void:
  Events.npc_focus_changed.connect(_on_npc_focus_changed)
  Events.dialogue_started.connect(_on_dialogue_started)
  Events.dialogue_ended.connect(_on_dialogue_ended)
  face_randomly()


func _exit_tree() -> void:
  Events.npc_focus_changed.disconnect(_on_npc_focus_changed)
  Events.dialogue_started.disconnect(_on_dialogue_started)
  Events.dialogue_ended.disconnect(_on_dialogue_ended)


func _on_npc_focus_changed(npc: Npc) -> void:
  if _in_dialogue:
    return
  var focused := npc == self
  sprite.material = outline_material if focused else null
  interaction_hint.visible = focused


func _on_dialogue_started(npc: Npc) -> void:
  if npc != self:
    return
  _in_dialogue = true
  sprite.material = null
  interaction_hint.visible = false


func _on_dialogue_ended() -> void:
  _in_dialogue = false
  var focused := Game.current_target_npc == self
  sprite.material = outline_material if focused else null
  interaction_hint.visible = focused


## Moves toward target position. Returns true when reached.
func move_to_position(target: Vector2, delta: float, threshold: float = 10.0) -> bool:
  var direction := global_position.direction_to(target)
  var distance := global_position.distance_to(target)

  if distance <= threshold:
    return true

  global_position += direction * move_speed * delta

  if direction.x != 0.0:
    flip_node.scale.x = sign(direction.x)

  return false


func face_right() -> void:
  flip_node.scale.x = 1


func face_left() -> void:
  flip_node.scale.x = -1


func face_towards(target: Vector2) -> void:
  flip_node.scale.x = sign(target.x - global_position.x)


func face_randomly() -> void:
  flip_node.scale.x = [-1, 1].pick_random()
