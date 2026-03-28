extends Node

# global game state

var in_dialogue := false

var current_target_npc: Npc = null:
  set(value):
    if current_target_npc == value:
      return
    current_target_npc = value
    Events.npc_focus_changed.emit(value)
