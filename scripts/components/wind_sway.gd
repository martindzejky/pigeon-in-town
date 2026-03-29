@tool
extends Node

## Continuously sways the target node using skew, simulating wind.
class_name WindSway

@export_category('Wind Sway')

## The node to sway. This node's skew will be animated.
@export var target: Node2D
## How far the node sways. Controls the maximum skew angle.
@export var strength: float = 0.05
## How fast the sway oscillates.
@export var speed: float = 1.0

@export_category('Testing')
@export_tool_button('Activate') var tool_activate = activate
@export_tool_button('Reset') var tool_reset = reset

# constant wind lean in the wind direction (positive = right)
const WIND_BIAS := 0.025
# small random phase so trees don't sway in perfect sync
const MAX_PHASE_OFFSET := 1.5

var _active := false
var _time := 0.0
@onready var _phase1 := randf_range(0.0, MAX_PHASE_OFFSET)
@onready var _phase2 := randf_range(0.0, MAX_PHASE_OFFSET)
@onready var _phase3 := randf_range(0.0, MAX_PHASE_OFFSET)


func _enter_tree() -> void:
  if not Engine.is_editor_hint():
    activate()


func _notification(what: int) -> void:
  if what == NOTIFICATION_EDITOR_PRE_SAVE:
    reset()


func _process(delta: float) -> void:
  if not _active:
    return

  _time += delta
  var t := _time * speed
  var wave := (
    sin(t + _phase1) * 0.5
    + sin(t * 0.7 + _phase2) * 0.3
    + cos(t * 1.3 + _phase3) * 0.2
  )
  target.skew = WIND_BIAS + wave * strength


func activate() -> void:
  assert(target, 'WindSway needs a target')
  _active = true


func reset() -> void:
  _active = false
  target.skew = 0.0
