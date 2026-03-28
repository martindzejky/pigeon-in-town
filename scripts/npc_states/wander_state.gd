extends NpcState

@export var wander_radius: float = 100.0
@export var wander_reached_distance: float = 10.0

var _starting_position: Vector2
var _wander_target: Vector2


func _ready() -> void:
  # store the npc's initial world position so we always wander around it
  _starting_position = npc.global_position


func enter() -> void:
  npc.animation.play('run')
  _wander_target = (
    _starting_position
    + Vector2.UP.rotated(randf_range(0.0, 2.0 * PI)) * randf_range(0.0, wander_radius)
  )


func exit() -> void:
  pass


func update(delta: float) -> void:
  if npc.move_to_position(_wander_target, delta, wander_reached_distance):
    state_machine.pop()
