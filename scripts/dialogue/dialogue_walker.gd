extends Node

class_name DialogueWalker

enum Speaker { PIGEON, NPC }

signal say(speaker: Speaker, text: String)
signal choose(options: Array[String])
signal finished()

var _current: Node = null


func reset() -> void:
  print('[walker] reset')
  _current = get_child(0)
  _process_current()


func advance() -> void:
  print('[walker] advance from: ', _current.name if _current else 'null')
  _next()
  _process_current()


func select_choice(index: int) -> void:
  print('[walker] select_choice: ', index)
  var option := _current.get_child(index) as DialogueOption
  _current = option.get_child(0)
  _process_current()


func _process_current() -> void:
  if _current == null:
    print('[walker] -> finished')
    finished.emit()
    Events.dialogue_ended.emit()
    return

  if _current is DialogueSay:
    var node := _current as DialogueSay
    var speaker_name := 'PIGEON' if node.speaker == Speaker.PIGEON else 'NPC'
    print('[walker] -> say [', speaker_name, ']: ', node.text)
    say.emit(node.speaker, node.text)
  elif _current is DialogueChoose:
    var options: Array[String] = []
    for child in _current.get_children():
      var option := child as DialogueOption
      options.append(option.label)
    print('[walker] -> choose: ', options)
    choose.emit(options)
  elif _current is DialogueOption:
    print('[walker] -> entering option: ', _current.name)
    _current = _current.get_child(0)
    _process_current()


func _next() -> void:
  var node := _current
  while node and node != self:
    var parent := node.get_parent()

    # when exiting an option branch, skip past the entire choose node
    if parent is DialogueChoose:
      print('[walker] _next: skipping up from option ', node.name, ' past choose')
      node = parent
      continue

    var idx := node.get_index()
    if idx + 1 < parent.get_child_count():
      _current = parent.get_child(idx + 1)
      print('[walker] _next: moved to sibling ', _current.name)
      return
    print('[walker] _next: no sibling, walking up from ', node.name)
    node = parent

  print('[walker] _next: reached root, conversation over')
  _current = null
