extends Node2D

class_name Npc

@export_category('Parts')
@export var flip_node: Node2D
@export var squash: Squash
@export var animation: AnimationPlayer
@export var sprite: Sprite2D

@export_category('Movement')
## Movement speed in pixels per second.
@export var move_speed: float = 150.0

var _outline_material: Material = preload('res://materials/outline.tres')


func _enter_tree() -> void:
  Events.npc_focus_changed.connect(_on_npc_focus_changed)
  face_randomly()


func _exit_tree() -> void:
  Events.npc_focus_changed.disconnect(_on_npc_focus_changed)


func _on_npc_focus_changed(npc: Npc) -> void:
  sprite.material = _outline_material if npc == self else null


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
