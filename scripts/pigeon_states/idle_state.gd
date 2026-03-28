extends PigeonState

func enter() -> void:
  pigeon.animation.play('idle')


func exit() -> void:
  pass


func update(_delta: float) -> void:
  var direction := Input.get_vector('move_left', 'move_right', 'move_up', 'move_down')
  if direction.length() > 0.0:
    state_machine.replace('run')
