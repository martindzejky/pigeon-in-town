extends Node

@export var pigeon: Pigeon
@export var dialogue: DialogueWalker

var _state_machine: StateMachine
var _dialogue_ui_anchor: DialogueUiAnchor


func _ready() -> void:
  Achievements.achievement_unlocked.connect(_on_achievement_unlocked)


func _on_achievement_unlocked(_ids: Array[String]) -> void:
  if not Achievements.all_achieved():
    return

  _state_machine = pigeon.get_node('state_machine')
  _dialogue_ui_anchor = pigeon.get_node('dialogue_ui_anchor')

  _state_machine.push('cutscene')
  pigeon.animation.play('idle')

  dialogue.say.connect(_on_say)
  dialogue.finished.connect(_on_finished)
  dialogue.reset()


func _on_say(_speaker: int, text: String) -> void:
  pigeon.animation.play('talk')
  _dialogue_ui_anchor.show_bubble(text)
  _dialogue_ui_anchor.advanced.connect(_on_advanced)
  _dialogue_ui_anchor.typing_finished.connect(_on_typing_finished)


func _on_typing_finished() -> void:
  pigeon.animation.play('idle')


func _on_advanced() -> void:
  _dialogue_ui_anchor.advanced.disconnect(_on_advanced)
  _dialogue_ui_anchor.typing_finished.disconnect(_on_typing_finished)
  _dialogue_ui_anchor.hide_bubble()
  dialogue.call_deferred('advance')


func _on_finished() -> void:
  _dialogue_ui_anchor.hide_bubble()
  _state_machine.pop()
  queue_free()
