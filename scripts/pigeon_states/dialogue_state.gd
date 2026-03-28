extends PigeonState

func _enter_tree() -> void:
  Events.dialogue_started.connect(_on_dialogue_started)


func _exit_tree() -> void:
  Events.dialogue_started.disconnect(_on_dialogue_started)


func enter() -> void:
  pigeon.animation.play('talk')
  Game.in_dialogue = true


func exit() -> void:
  Game.in_dialogue = false


func update(_delta: float) -> void:
  pass


func _on_dialogue_started(_npc: Npc) -> void:
  state_machine.push(name)
