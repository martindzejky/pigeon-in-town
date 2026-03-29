extends Node

# global game state

## global npc memory shared by all NPCs to track cross-conversation flags
var npc_memory: NpcMemory = NpcMemory.new()


func _ready() -> void:
  # cuthbert declared the pigeon a divine messenger
  npc_memory.set_flag('g_pigeon_is_prophet', false)
  # sir oinksworth knighted the pigeon
  npc_memory.set_flag('g_pigeon_is_knight', false)
  # pigeon agreed to spread word of the ghosts for mildred
  npc_memory.set_flag('g_ghost_rumor', false)
  # someone was actually scared by the ghost rumor (bertram)
  npc_memory.set_flag('g_someone_scared', false)
  # pigeon learned from agnes that cornelius has been alone for 30 years
  npc_memory.set_flag('g_cornelius_secret', false)

## the npc character the pigeon is currently interacting with
var current_target_npc: Npc = null:
  set(value):
    if current_target_npc == value:
      return
    current_target_npc = value
    Events.npc_focus_changed.emit(value)
