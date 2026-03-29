extends Node

# global game state

## global npm memory shared by all NPCs to track cross-conversation flags
var npc_memory: NpcMemory = NpcMemory.new()

## the npc character the pigeon is currently interacting with
var current_target_npc: Npc = null:
  set(value):
    if current_target_npc == value:
      return
    current_target_npc = value
    Events.npc_focus_changed.emit(value)
