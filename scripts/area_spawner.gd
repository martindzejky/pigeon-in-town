extends Node2D

## objects to randomly pick from when spawning
@export var objects: Array[PackedScene] = []

## objects per 10 000 px² (roughly per 100x100 area)
@export var density := 1.0

@onready var _polygon: Polygon2D = $polygon


func _ready() -> void:
  _polygon.visible = false
  var points: PackedVector2Array = _polygon.polygon
  var area := _calculate_polygon_area(points)
  var count := int(area / 10_000.0 * density)

  for i in count:
    var scene: PackedScene = objects.pick_random()
    var instance: Node = scene.instantiate()
    var pos := _random_point_in_polygon(points)
    if instance is Node2D:
      (instance as Node2D).position = pos
    add_child(instance)


func _calculate_polygon_area(points: PackedVector2Array) -> float:
  var area := 0.0
  var n := points.size()
  for i in n:
    var j := (i + 1) % n
    area += points[i].x * points[j].y
    area -= points[j].x * points[i].y
  return absf(area) * 0.5


func _random_point_in_polygon(points: PackedVector2Array) -> Vector2:
  var rect := _bounding_rect(points)
  for attempt in 100:
    var candidate := Vector2(
      randf_range(rect.position.x, rect.end.x),
      randf_range(rect.position.y, rect.end.y),
    )
    if Geometry2D.is_point_in_polygon(candidate, points):
      return candidate
  return rect.get_center()


func _bounding_rect(points: PackedVector2Array) -> Rect2:
  var min_pt := points[0]
  var max_pt := points[0]
  for p in points:
    min_pt = Vector2(minf(min_pt.x, p.x), minf(min_pt.y, p.y))
    max_pt = Vector2(maxf(max_pt.x, p.x), maxf(max_pt.y, p.y))
  return Rect2(min_pt, max_pt - min_pt)
