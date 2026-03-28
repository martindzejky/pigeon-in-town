extends NpcState

@export var dialogue_ui_anchor: DialogueUiAnchor
@export var talking_state: State


func _enter_tree() -> void:
  Events.dialogue_started.connect(_on_dialogue_started)


func _exit_tree() -> void:
  Events.dialogue_started.disconnect(_on_dialogue_started)


func enter() -> void:
  npc.animation.play('idle')

  var pigeon := get_tree().get_first_node_in_group('pigeon') as Node2D
  if pigeon:
    npc.face_towards(pigeon.global_position)

  npc.dialogue_walker.say.connect(_on_say)
  npc.dialogue_walker.finished.connect(_on_finished)


func exit() -> void:
  npc.dialogue_walker.say.disconnect(_on_say)
  npc.dialogue_walker.finished.disconnect(_on_finished)


func update(_delta: float) -> void:
  pass


func _on_dialogue_started(target_npc: Npc) -> void:
  if target_npc == npc:
    state_machine.push(name)
    npc.dialogue_walker.call_deferred('reset')


func _on_say(speaker: int, text: String) -> void:
  if speaker == DialogueWalker.Speaker.NPC:
    talking_state.line_text = text
    state_machine.push(talking_state.name)


func _on_finished() -> void:
  dialogue_ui_anchor.hide_bubble()
  state_machine.pop()
