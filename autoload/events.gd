extends Node

# global game event bus

signal npc_focus_changed(npc: Npc)
signal dialogue_started(npc: Npc)
signal dialogue_ended()
signal main_menu_entered()
signal level_select_exiting()
signal npc_flag_set(flag: String, value: bool)
signal global_flag_set(flag: String, value: bool)
