extends Node2D

class_name Shadow

@export var remote_transform: RemoteTransform2D
@export var sprite: Sprite2D


func _enter_tree() -> void:
  assert(Shadows.shadow_canvas_group, 'Shadow canvas group not found')
  sprite.owner = null
  sprite.reparent(Shadows.shadow_canvas_group)
  remote_transform.remote_path = sprite.get_path()


func _exit_tree() -> void:
  sprite.reparent(remote_transform)
  sprite.owner = self
  remote_transform.remote_path = NodePath('')


func _on_visibility_changed() -> void:
  # must propagate visibility changes to the shadow sprite which is not a child of this node
  sprite.visible = is_visible_in_tree()
