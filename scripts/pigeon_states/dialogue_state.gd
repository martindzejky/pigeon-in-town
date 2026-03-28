extends PigeonState

@export var dialogue_ui_anchor: DialogueUiAnchor
@export var talking_state: State
@export var choice_state: State

var _walker: DialogueWalker
var _npc: Npc


func _enter_tree() -> void:
  Events.dialogue_started.connect(_on_dialogue_started)


func _exit_tree() -> void:
  Events.dialogue_started.disconnect(_on_dialogue_started)


func enter() -> void:
  pigeon.animation.play('idle')
  pigeon.flip_node.scale.x = sign(_npc.global_position.x - pigeon.global_position.x)
  _walker.say.connect(_on_say)
  _walker.choose.connect(_on_choose)
  _walker.finished.connect(_on_finished)


func exit() -> void:
  _walker.say.disconnect(_on_say)
  _walker.choose.disconnect(_on_choose)
  _walker.finished.disconnect(_on_finished)
  _walker = null
  _npc = null


func update(_delta: float) -> void:
  pass


func _on_dialogue_started(npc: Npc) -> void:
  _npc = npc
  _walker = npc.dialogue_walker
  state_machine.push(name)


func _on_say(speaker: int, text: String) -> void:
  if speaker == DialogueWalker.Speaker.PIGEON:
    talking_state.line_text = text
    talking_state.walker = _walker
    state_machine.push(talking_state.name)


func _on_choose(options: Array[String]) -> void:
  choice_state.options = options
  choice_state.walker = _walker
  state_machine.push(choice_state.name)


func _on_finished() -> void:
  dialogue_ui_anchor.hide_bubble()
  state_machine.pop()
