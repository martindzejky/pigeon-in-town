extends Node

class_name NpcMemory

signal flag_set(flag: String, value: bool)

var _flags: Dictionary[String, bool] = { }


# only runs for local NPC memories (scene nodes), not for
# Game.npc_memory which is created with .new() and never added to tree
func _ready() -> void:
  flag_set.connect(
    func(f: String, v: bool) -> void:
      Events.npc_flag_set.emit(f, v)
  )


func has_flag(flag: String) -> bool:
  return _flags.get(flag, false)


func set_flag(flag: String, value: bool = true) -> void:
  _flags[flag] = value
  flag_set.emit(flag, value)
