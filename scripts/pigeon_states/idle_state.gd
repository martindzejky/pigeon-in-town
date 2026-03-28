extends PigeonState

func enter() -> void:
  pigeon.animation.play('idle')


func exit() -> void:
  pass


func update(_delta: float) -> void:
  if Input.is_action_just_pressed('interact') and Game.current_target_npc:
    Events.dialogue_started.emit(Game.current_target_npc)
    return

  var direction := Input.get_vector('move_left', 'move_right', 'move_up', 'move_down')
  if direction.length() > 0.0:
    state_machine.replace('run')
