@tool
extends Container

class_name PassthroughContainer

@export var center_pivot_offset := false:
  set(value):
    center_pivot_offset = value
    queue_sort()


func _ready() -> void:
  sort_children.connect(_on_sort_children)


func _get_configuration_warnings() -> PackedStringArray:
  var control_count := 0
  for child in get_children():
    if child is Control:
      control_count += 1
  if control_count > 1:
    return PackedStringArray(['PassthroughContainer only works with a single Control child!'])
  return PackedStringArray()


func _on_sort_children() -> void:
  do_sort()


func do_sort() -> void:
  if get_parent() is PassthroughContainer:
    (get_parent() as PassthroughContainer).do_sort()
    return

  var root_child := get_first_child_control()
  var passthrough_list: Array[PassthroughContainer] = []

  while root_child is PassthroughContainer:
    passthrough_list.append(root_child as PassthroughContainer)
    root_child = (root_child as PassthroughContainer).get_first_child_control()

  if root_child:
    size_flags_horizontal = root_child.size_flags_horizontal
    size_flags_vertical = root_child.size_flags_vertical

    root_child.size = Vector2.ZERO
    custom_minimum_size = root_child.get_combined_minimum_size()
    root_child.size = size

    if center_pivot_offset:
      root_child.pivot_offset = root_child.size / 2.0
    else:
      root_child.pivot_offset = Vector2.ZERO
    pivot_offset = root_child.pivot_offset

    if Engine.is_editor_hint():
      root_child.position = Vector2.ZERO

  for pt in passthrough_list:
    pt.center_pivot_offset = center_pivot_offset
    pt.size_flags_horizontal = size_flags_horizontal
    pt.size_flags_vertical = size_flags_vertical
    pt.custom_minimum_size = custom_minimum_size
    pt.size = size
    pt.pivot_offset = pivot_offset


func get_first_child_control() -> Control:
  for child in get_children():
    if child is Control:
      return child as Control
  return null
