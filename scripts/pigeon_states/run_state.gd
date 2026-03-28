extends PigeonState

func enter() -> void:
  pigeon.animation.play('run')


func exit() -> void:
  pass


func update(delta: float) -> void:
  var direction := Input.get_vector('move_left', 'move_right', 'move_up', 'move_down')

  if direction.length() > 0.0:
    pigeon.global_position += direction * pigeon.move_speed * delta

    if direction.x != 0.0:
      pigeon.flip_node.scale.x = sign(direction.x)
  else:
    state_machine.pop()
