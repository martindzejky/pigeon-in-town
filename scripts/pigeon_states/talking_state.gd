extends PigeonState

@export var dialogue_ui_anchor: DialogueUiAnchor

var line_text: String
var walker: DialogueWalker


func enter() -> void:
  pigeon.animation.play('talk')
  dialogue_ui_anchor.show_bubble(line_text)
  dialogue_ui_anchor.advanced.connect(_on_advanced)
  dialogue_ui_anchor.typing_finished.connect(_on_typing_finished)


func exit() -> void:
  dialogue_ui_anchor.advanced.disconnect(_on_advanced)
  dialogue_ui_anchor.typing_finished.disconnect(_on_typing_finished)


func update(_delta: float) -> void:
  pass


func _on_typing_finished() -> void:
  pigeon.animation.play('idle')


func _on_advanced() -> void:
  dialogue_ui_anchor.hide_bubble()
  state_machine.pop()
  walker.call_deferred('advance')
