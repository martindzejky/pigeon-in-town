extends Node

# tracks achievement state and emits when new ones should be revealed

signal achievement_unlocked(ids: Array[String])

const DEFINITIONS: Array[Dictionary] = [
  { 'id': 'feathered_prophet', 'title': 'The Feathered Prophet', 'hint': 'Receive a divine calling.', 'art': 'res://sprites/ui/card_feathered_prophet.png' },
  { 'id': 'sir_pigeon', 'title': 'Sir Pigeon of the Puddle', 'hint': 'Earn a noble title.', 'art': 'res://sprites/ui/card_sir_pigeon.png' },
  { 'id': 'prophet_and_knight', 'title': 'Prophet and Knight', 'hint': 'Be both holy and noble.', 'art': 'res://sprites/ui/card_prophet_and_knight.png' },
  { 'id': 'great_haunting', 'title': 'The Great Haunting', 'hint': 'Spread a spooky rumor.', 'art': 'res://sprites/ui/card_great_haunting.png' },
  { 'id': 'unlikely_friends', 'title': 'Unlikely Friends', 'hint': 'Befriend someone lonely.', 'art': 'res://sprites/ui/card_unlikely_friends.png' },
]

var _achieved: Dictionary[String, bool] = { }
var _revealed: Dictionary[String, bool] = { }
var _pending_reveals: Array[String] = []


func _ready() -> void:
  for def in DEFINITIONS:
    _achieved[def['id']] = false
    _revealed[def['id']] = false

  Events.global_flag_set.connect(_on_global_flag_set)
  Events.npc_flag_set.connect(_on_npc_flag_set)
  Events.dialogue_ended.connect(_on_dialogue_ended)


func is_achieved(id: String) -> bool:
  return _achieved.get(id, false)


func is_revealed(id: String) -> bool:
  return _revealed.get(id, false)


func mark_revealed(id: String) -> void:
  _revealed[id] = true


func _on_global_flag_set(flag: String, value: bool) -> void:
  # just plain old hardcoded logic...
  if not value:
    return
  if flag == 'g_pigeon_is_prophet':
    _try_unlock('feathered_prophet')
    if Game.npc_memory.has_flag('g_pigeon_is_knight'):
      _try_unlock('prophet_and_knight')
  elif flag == 'g_pigeon_is_knight':
    _try_unlock('sir_pigeon')
    if Game.npc_memory.has_flag('g_pigeon_is_prophet'):
      _try_unlock('prophet_and_knight')
  elif flag == 'g_someone_scared':
    _try_unlock('great_haunting')


func _on_npc_flag_set(flag: String, value: bool) -> void:
  if not value:
    return
  if flag == 'became_friends':
    _try_unlock('unlikely_friends')


func _on_dialogue_ended() -> void:
  if _pending_reveals.is_empty():
    return
  var batch := _pending_reveals.duplicate()
  _pending_reveals.clear()
  achievement_unlocked.emit(batch)


func _try_unlock(id: String) -> void:
  if _achieved[id]:
    return
  _achieved[id] = true
  _pending_reveals.append(id)
