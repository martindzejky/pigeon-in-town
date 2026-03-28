@tool
extends Node

## Simple component that performs a spring-based squash animation on the target node.
class_name Squash

@export_category('Squash')

## The node to perform the squash animation on. This node will be scaled.
@export var target: Node2D
## How hard the initial squash punch is.
@export var force: float = 1.0
## How quickly the bouncing settles. Higher = stops sooner, lower = wobbles longer.
@export var damping: float = 1.0
## How fast the spring bounces back and forth. Higher = snappier, lower = lazier.
@export var stiffness: float = 1.0

@export_category('Testing')
@export_tool_button('Squash') var tool_squash = squash

# emitted when the squash animation is finished
signal finished

const FORCE_BASE := 12.0
const DAMPING_BASE := 14.0
const SPRING_STRENGTH := 580.0
const SQUASH_AXIS := Vector2(1.0, -1.0)
const REST_SCALE := Vector2.ONE
const REST_TOLERANCE := 0.01
const MIN_SCALE := 0.4
const MAX_SCALE := 1.8

var _offset := 0.0
var _velocity := 0.0
var _active := false


func _physics_process(delta: float) -> void:
  if not _active:
    return

  var min_offset := maxf(MIN_SCALE - 1.0, 1.0 - MAX_SCALE)
  var max_offset := minf(MAX_SCALE - 1.0, 1.0 - MIN_SCALE)
  var acceleration := (-_offset * SPRING_STRENGTH * stiffness) - (_velocity * DAMPING_BASE * damping)
  _velocity += acceleration * delta
  _offset += _velocity * delta
  _offset = clampf(_offset, min_offset, max_offset)
  target.scale = REST_SCALE + (SQUASH_AXIS * _offset)

  if absf(_velocity) <= REST_TOLERANCE and absf(_offset) <= REST_TOLERANCE:
    target.scale = REST_SCALE
    _offset = 0.0
    _velocity = 0.0
    _active = false
    finished.emit()


func squash() -> void:
  assert(target, 'Squash needs a target')
  var min_offset := maxf(MIN_SCALE - 1.0, 1.0 - MAX_SCALE)
  var max_offset := minf(MAX_SCALE - 1.0, 1.0 - MIN_SCALE)
  _offset = target.scale.x - REST_SCALE.x
  _offset = clampf(_offset, min_offset, max_offset)
  _velocity = FORCE_BASE * force
  _active = true
