extends PigeonState

func enter() -> void:
  pigeon.animation.play('run')


func exit() -> void:
  pass


func _unhandled_input(event: InputEvent) -> void:
  if not is_current():
    return
  if event.is_action_pressed('interact') and Game.current_target_npc:
    get_viewport().set_input_as_handled()
    Events.dialogue_started.emit(Game.current_target_npc)


func update(delta: float) -> void:
  var direction := Input.get_vector('move_left', 'move_right', 'move_up', 'move_down')

  if direction.length() > 0.0:
    pigeon.global_position += direction * pigeon.move_speed * delta

    if direction.x != 0.0:
      pigeon.flip_node.scale.x = sign(direction.x)
  else:
    state_machine.pop()
