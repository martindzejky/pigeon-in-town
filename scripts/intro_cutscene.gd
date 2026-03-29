extends Node

@export var enabled := true
@export var pigeon: Pigeon
@export var start_position: Marker2D
@export var end_position: Marker2D
@export var dialogue: DialogueWalker

var _state_machine: StateMachine
var _dialogue_ui_anchor: DialogueUiAnchor


func _ready() -> void:
  if not enabled:
    queue_free()
    return

  _state_machine = pigeon.get_node('state_machine')
  _dialogue_ui_anchor = pigeon.get_node('dialogue_ui_anchor')

  _state_machine.push('cutscene')
  pigeon.global_position = start_position.global_position

  # flip toward destination
  var dir := end_position.global_position - start_position.global_position
  if dir.x != 0.0:
    pigeon.flip_node.scale.x = sign(dir.x)

  pigeon.animation.play('run')

  var distance := pigeon.global_position.distance_to(end_position.global_position)
  var duration := distance / pigeon.move_speed
  var tween := create_tween()
  tween.tween_property(pigeon, 'global_position', end_position.global_position, duration)
  tween.finished.connect(_on_run_finished)


func _on_run_finished() -> void:
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
