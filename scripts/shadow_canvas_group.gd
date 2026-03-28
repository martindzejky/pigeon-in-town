extends CanvasGroup
class_name ShadowCanvasGroup

func _enter_tree() -> void:
	assert(!Shadows.shadow_canvas_group, 'Shadow canvas group already exists')
	Shadows.shadow_canvas_group = self

func _exit_tree() -> void:
	Shadows.shadow_canvas_group = null
