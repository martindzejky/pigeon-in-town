extends Node

# background music that persists across scenes

const FULL_VOLUME_DB := -8.0
const SILENT_DB := -40.0
const FADE_DURATION := 5.0

var _player: AudioStreamPlayer
var _fade_tween: Tween


func _ready() -> void:
  _player = AudioStreamPlayer.new()
  _player.stream = preload('res://music/main_menu.mp3')
  _player.bus = 'music'
  _player.volume_db = FULL_VOLUME_DB
  add_child(_player)

  Events.main_menu_entered.connect(_on_main_menu_entered)
  Events.level_select_exiting.connect(_on_level_select_exiting)


func _on_main_menu_entered() -> void:
  if _player.playing:
    return
  _kill_fade()
  _player.volume_db = FULL_VOLUME_DB
  _player.play()


func _on_level_select_exiting() -> void:
  if not _player.playing:
    return
  _kill_fade()
  _fade_tween = create_tween()
  _fade_tween.tween_property(_player, 'volume_db', SILENT_DB, FADE_DURATION)
  _fade_tween.tween_callback(_player.stop)


func _kill_fade() -> void:
  if _fade_tween and _fade_tween.is_running():
    _fade_tween.kill()
