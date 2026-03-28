extends Area2D

# detects NPCs in range, tracks the closest one, and triggers dialogue on interact.
# attached to an Area2D child of the pigeon.

var _npcs_in_range: Array[Npc] = []


func _process(_delta: float) -> void:
  _update_closest()


func _on_area_entered(area: Area2D) -> void:
  var npc := area.get_parent() as Npc
  if npc and npc not in _npcs_in_range:
    _npcs_in_range.append(npc)


func _on_area_exited(area: Area2D) -> void:
  var npc := area.get_parent() as Npc
  if npc:
    _npcs_in_range.erase(npc)


func _update_closest() -> void:
  if _npcs_in_range.is_empty():
    Game.current_target_npc = null
    return

  var closest: Npc = _npcs_in_range[0]
  var closest_dist := global_position.distance_squared_to(closest.global_position)

  for npc in _npcs_in_range:
    var dist := global_position.distance_squared_to(npc.global_position)
    if dist < closest_dist:
      closest = npc
      closest_dist = dist

  Game.current_target_npc = closest
