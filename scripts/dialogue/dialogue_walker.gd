extends Node

class_name DialogueWalker

enum Speaker { PIGEON, NPC }

signal say(speaker: Speaker, text: String)
signal choose(options: Array[String])
signal finished()

var _current: Node = null


func reset() -> void:
  _current = get_child(0)
  _process_current()


func advance() -> void:
  _next()
  _process_current()


func select_choice(index: int) -> void:
  var option := _current.get_child(index) as DialogueOption
  _current = option.get_child(0)
  _process_current()


func _process_current() -> void:
  if _current == null:
    finished.emit()
    return

  if _current is DialogueSay:
    var node := _current as DialogueSay
    say.emit(node.speaker, node.text)
  elif _current is DialogueChoose:
    var options: Array[String] = []
    for child in _current.get_children():
      var option := child as DialogueOption
      options.append(option.label)
    choose.emit(options)
  elif _current is DialogueOption:
    _current = _current.get_child(0)
    _process_current()


func _next() -> void:
  var node := _current
  while node and node != self:
    var parent := node.get_parent()

    # when exiting an option branch, skip past the entire choose node
    if parent is DialogueChoose:
      node = parent
      continue

    var idx := node.get_index()
    if idx + 1 < parent.get_child_count():
      _current = parent.get_child(idx + 1)
      return
    node = parent

  _current = null
