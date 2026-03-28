extends NpcState

func _enter_tree() -> void:
  Events.dialogue_started.connect(_on_dialogue_started)


func _exit_tree() -> void:
  Events.dialogue_started.disconnect(_on_dialogue_started)


func enter() -> void:
  npc.animation.play('talk')


func exit() -> void:
  pass


func update(_delta: float) -> void:
  pass


func _on_dialogue_started(target_npc: Npc) -> void:
  if target_npc == npc:
    state_machine.push(name)
