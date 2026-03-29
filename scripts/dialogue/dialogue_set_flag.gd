extends Node

class_name DialogueSetFlag

## flag name to set on the NPC's NpcMemory component
@export var flag: String

## value to set
@export var value: bool = true

## when true, sets on Game.npc_memory instead of the local NPC memory
@export var global: bool = false
