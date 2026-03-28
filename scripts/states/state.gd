@abstract
extends Node

class_name State

# Base class for all states. States are managed by a StateMachine.
# enter and exit are called when the state is pushed or popped from the state machine.
# update is called every frame while the state is the current state.
# * Note that you can still use _process if some logic needs to run regardless of
# * whether the state is the current state, because states are normal nodes in the scene tree.

@export var state_machine: StateMachine


func is_current() -> bool:
  return state_machine.get_current() == self


@abstract
func enter() -> void


@abstract
func exit() -> void


@abstract
func update(delta: float) -> void
