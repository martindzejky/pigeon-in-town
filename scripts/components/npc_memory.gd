extends Node

class_name NpcMemory

var _flags: Dictionary[String, bool] = { }


func has_flag(flag: String) -> bool:
  return _flags.get(flag, false)


func set_flag(flag: String, value: bool = true) -> void:
  _flags[flag] = value
