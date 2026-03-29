extends Node

class_name DialogueCondition

## flag name to check on the NPC's NpcMemory component
@export var flag: String

## when true, checks Game.npc_memory instead of the local NPC memory
@export var global: bool = false
