extends Node

@export var bounds: Rect2 = Rect2(-1400, -900, 2800, 1800)

var _pigeon: Node2D


func _ready() -> void:
  _pigeon = get_tree().get_first_node_in_group('pigeon')


func _process(_delta: float) -> void:
  if _pigeon:
    _pigeon.global_position = _pigeon.global_position.clamp(
      bounds.position,
      bounds.end,
    )
