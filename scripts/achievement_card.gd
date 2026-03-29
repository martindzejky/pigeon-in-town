extends Control

@export var checkbox: TextureRect
@export var card_art: TextureRect
@export var achievement_sound: AudioStreamPlayer
@export var stamp_sound: AudioStreamPlayer

var _achievement_id: String = ''
var _unlocked: bool = false


func setup(id: String, art_path: String) -> void:
  _achievement_id = id
  card_art.texture = load(art_path)
  refresh()


func refresh() -> void:
  _unlocked = Achievements.is_achieved(_achievement_id)
  modulate = Color.WHITE if _unlocked else Color(0.4, 0.4, 0.4, 0.6)
  checkbox.visible = _unlocked


func play_reveal() -> void:
  _unlocked = true
  modulate = Color.WHITE
  checkbox.visible = true
  checkbox.modulate = Color.TRANSPARENT

  # card art scales down from 2x
  card_art.scale = Vector2(2.0, 2.0)
  var tween := create_tween()
  tween.tween_callback(achievement_sound.play)
  tween.tween_property(card_art, 'scale', Vector2.ONE, 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)

  # checkbox drops in like a stamp: starts slow, accelerates to impact
  tween.tween_property(checkbox, 'scale', Vector2.ONE, 1.0).from(Vector2(4.0, 4.0)).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
  tween.parallel().tween_property(checkbox, 'modulate', Color.WHITE, 1.0).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)

  # stamp lands
  tween.tween_callback(stamp_sound.play)
  tween.tween_property(self, 'scale', Vector2(0.9, 0.9), 0.08).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
  tween.tween_property(self, 'scale', Vector2.ONE, 0.15).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
