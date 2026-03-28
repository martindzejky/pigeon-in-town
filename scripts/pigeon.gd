extends Node2D

class_name Pigeon

@export_category('Parts')
@export var flip_node: Node2D
@export var squash: Squash
@export var animation: AnimationPlayer

@export_category('Movement')
## Movement speed in pixels per second.
@export var move_speed: float = 200.0
