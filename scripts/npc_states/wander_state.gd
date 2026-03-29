extends NpcState

@export var wander_radius: float = 100.0
@export var wander_reached_distance: float = 10.0
@export var wander_timeout_sec: float = 4.0

var _starting_position: Vector2
var _wander_target: Vector2
var _timeout_timer: Timer


func _ready() -> void:
  _starting_position = npc.global_position
  _timeout_timer = Timer.new()
  _timeout_timer.wait_time = wander_timeout_sec
  _timeout_timer.one_shot = true
  _timeout_timer.timeout.connect(_on_timeout)
  add_child(_timeout_timer)


func enter() -> void:
  npc.animation.play('run')
  _wander_target = (
    _starting_position
    + Vector2.UP.rotated(randf_range(0.0, 2.0 * PI)) * randf_range(0.0, wander_radius)
  )
  _timeout_timer.start()


func exit() -> void:
  _timeout_timer.stop()


func update(delta: float) -> void:
  if npc.move_to_position(_wander_target, delta, wander_reached_distance):
    state_machine.pop()


func _on_timeout() -> void:
  if is_current():
    state_machine.pop()
