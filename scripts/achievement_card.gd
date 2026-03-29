extends PanelContainer

@export var title_label: Label
@export var checkbox: TextureRect
@export var card_art: TextureRect

var _achievement_id: String = ''
var _unlocked: bool = false


func setup(id: String, title: String) -> void:
  _achievement_id = id
  title_label.text = title
  refresh()


func refresh() -> void:
  _unlocked = Achievements.is_achieved(_achievement_id)
  modulate = Color.WHITE if _unlocked else Color(0.4, 0.4, 0.4, 0.6)
  checkbox.visible = _unlocked


func play_reveal() -> void:
  refresh()
  var tween := create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
  tween.tween_property(self, 'scale', Vector2(1.15, 1.15), 0.2)
  tween.tween_property(self, 'scale', Vector2.ONE, 0.2)
