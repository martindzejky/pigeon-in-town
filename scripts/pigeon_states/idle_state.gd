extends PigeonState

func enter() -> void:
  pigeon.animation.play('idle')


func exit() -> void:
  pass


func _unhandled_input(event: InputEvent) -> void:
  if not is_current():
    return
  if event.is_action_pressed('interact') and Game.current_target_npc:
    get_viewport().set_input_as_handled()
    Events.dialogue_started.emit(Game.current_target_npc)


func update(_delta: float) -> void:
  var direction := Input.get_vector('move_left', 'move_right', 'move_up', 'move_down')
  if direction.length() > 0.0:
    state_machine.replace('run')
