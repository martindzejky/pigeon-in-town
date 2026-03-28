extends Node2D

class_name Npc

@export_category('Parts')
@export var flip_node: Node2D
@export var squash: Squash
@export var animation: AnimationPlayer

@export_category('Movement')
## Movement speed in pixels per second.
@export var move_speed: float = 150.0


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
