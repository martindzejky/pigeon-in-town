extends CanvasLayer

# autoload for scene transitions

var _overlay: ColorRect
var _is_transitioning: bool = false


func _ready() -> void:
  layer = 100
  _overlay = ColorRect.new()
  _overlay.color = Color(0, 0, 0, 0)
  _overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE
  _overlay.set_anchors_preset(Control.PRESET_FULL_RECT)
  add_child(_overlay)


func change_scene(path: String) -> void:
  if _is_transitioning:
    return
  _is_transitioning = true
  _overlay.mouse_filter = Control.MOUSE_FILTER_STOP

  var tween := create_tween()
  tween.tween_property(_overlay, 'color:a', 1.0, 0.4)
  await tween.finished

  get_tree().change_scene_to_file(path)

  # wait a frame for the new scene to initialize
  await get_tree().process_frame

  var fade_in := create_tween()
  fade_in.tween_property(_overlay, 'color:a', 0.0, 0.4)
  await fade_in.finished

  _overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE
  _is_transitioning = false
