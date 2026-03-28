extends NpcState

@export var wander_min_sec: float = 3.0
@export var wander_max_sec: float = 7.0

var _wander_timer: RandomTimer


func _ready() -> void:
  _wander_timer = RandomTimer.new()
  _wander_timer.min_time = wander_min_sec
  _wander_timer.max_time = wander_max_sec
  _wander_timer.one_shot = false
  _wander_timer.timeout.connect(_on_wander_timer_timeout)
  add_child(_wander_timer)


func enter() -> void:
  npc.animation.play('idle')
  _wander_timer.start()


func exit() -> void:
  _wander_timer.stop()


func update(_delta: float) -> void:
  pass


func _on_wander_timer_timeout() -> void:
  if is_current():
    state_machine.push('wander')
