extends PigeonState

@export var dialogue_ui_anchor: DialogueUiAnchor

var options: Array[String]
var walker: DialogueWalker


func enter() -> void:
  pigeon.animation.play('idle')
  dialogue_ui_anchor.show_choices(options)
  dialogue_ui_anchor.choice_selected.connect(_on_choice_selected)


func exit() -> void:
  dialogue_ui_anchor.choice_selected.disconnect(_on_choice_selected)


func update(_delta: float) -> void:
  pass


func _on_choice_selected(index: int) -> void:
  dialogue_ui_anchor.hide_bubble()
  walker.select_choice(index)
  state_machine.pop()
