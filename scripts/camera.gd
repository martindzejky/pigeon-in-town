extends Camera2D

@export var dialogue_y_offset := -200.0
@export var dialogue_zoom := 0.34
@export var zoom_speed := 3.0

var _default_zoom: float
var _pigeon: Node2D
var _npc: Npc
var _in_dialogue := false


func _ready() -> void:
  _default_zoom = zoom.x


func _enter_tree() -> void:
  Events.dialogue_started.connect(_on_dialogue_started)
  Events.dialogue_ended.connect(_on_dialogue_ended)


func _exit_tree() -> void:
  Events.dialogue_started.disconnect(_on_dialogue_started)
  Events.dialogue_ended.disconnect(_on_dialogue_ended)


func _process(delta: float) -> void:
  if not _pigeon:
    _pigeon = get_tree().get_first_node_in_group('pigeon')
    assert(_pigeon, 'Pigeon not found')

  var target_zoom := dialogue_zoom if _in_dialogue else _default_zoom
  zoom = zoom.lerp(Vector2.ONE * target_zoom, clamp(zoom_speed * delta, 0.0, 1.0))

  if _in_dialogue and _npc:
    var mid_x := (_pigeon.global_position.x + _npc.global_position.x) * 0.5
    var mid_y := (_pigeon.global_position.y + _npc.global_position.y) * 0.5
    global_position = Vector2(mid_x, mid_y + dialogue_y_offset)
  else:
    global_position = _pigeon.global_position


func _on_dialogue_started(npc: Npc) -> void:
  _npc = npc
  _in_dialogue = true


func _on_dialogue_ended() -> void:
  _in_dialogue = false
  _npc = null
