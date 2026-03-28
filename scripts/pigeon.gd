extends Node2D

class_name Pigeon

@export_category('Parts')
@export var flip_node: Node2D
@export var squash: Squash
@export var animation: AnimationPlayer

@export_category('Movement')
## Movement speed in pixels per second.
@export var move_speed: float = 200.0


func _process(delta: float) -> void:
  var direction := Input.get_vector('move_left', 'move_right', 'move_up', 'move_down')

  if direction.length() > 0.0:
    global_position += direction * move_speed * delta

    if direction.x != 0.0:
      flip_node.scale.x = sign(direction.x)

    if animation.current_animation != 'run':
      animation.play('run')
  else:
    if animation.current_animation != 'idle':
      animation.play('idle')
