extends Node

class_name StateMachine

# Stacked state machine. The current state is always at the front of the stack.
# Use push, pop, replace, and enqueue to manage the state stack.
# The state machine ensures that there is always at least one state on the stack,
# so states can always call pop() to return to the default state.
# It calls enter, exit, and update on the current state.
#
# Common patterns:
# - transient state: call pop() once finished
# - switch to a new state: call replace() with the new state name
# - switch to a sequence of states: call replace() with the last ("main") state in
#   the sequence and then push() the others
# - let the current state finish but schedule the next one: call enqueue() with the
#   next state name, then later call pop()

var _state_stack: Array[State] = [] # 0 is the current state
var _last_state: State = null
var _update_scheduled := false


func _ready() -> void:
  assert(get_child_count() > 0, 'State machine must have at least one state')
  push_default()


func _process(delta: float) -> void:
  get_current().update(delta)


func get_current() -> State:
  return _state_stack[0]


func push_default() -> void:
  push(get_child(0).name)


func push(state_name: String) -> void:
  if not has_node(state_name):
    push_error('State not found: ', state_name)
    return

  var state = get_node(state_name)
  if not state is State:
    push_error('Node is not a valid state: ', state_name)
    return

  _state_stack.push_front(state)
  _schedule_update()


func enqueue(state_name: String) -> void:
  if not has_node(state_name):
    push_error('State not found: ', state_name)
    return

  var state = get_node(state_name)
  if not state is State:
    push_error('Node is not a valid state: ', state_name)
    return

  _state_stack.append(state)
  _schedule_update() # should not be needed, but just in case


func replace(state_name: String) -> void:
  if not has_node(state_name):
    push_error('State not found: ', state_name)
    pop() # don't forget to at least pop the current state
    return

  var state = get_node(state_name)
  if not state is State:
    push_error('Node is not a valid state: ', state_name)
    pop() # don't forget to at least pop the current state
    return

  _state_stack[0] = state
  _schedule_update()


func pop() -> void:
  _state_stack.pop_front()
  _schedule_update()

  # ensure there is always a default state
  if _state_stack.is_empty():
    push_default()


func _schedule_update() -> void:
  if _update_scheduled:
    return

  _update_scheduled = true
  call_deferred('_update_states')


func _update_states() -> void:
  _update_scheduled = false
  var new_current = get_current()
  if new_current == _last_state:
    return

  if _last_state:
    _last_state.exit()
  new_current.enter()
  _last_state = new_current
