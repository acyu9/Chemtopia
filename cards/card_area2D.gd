extends Area2D

# selection is true or false
#signal selection_toggled(selection)
#
#@export var exclusive = true
#
#var selected = false : set = set_selected
#
#func set_selected(selection):
#	if selection:
#		_make_exclusive()
#		add_to_group("selected")
#	else:
#		remove_from_group("selected")
#
#	selected = selection
#	selection_toggled.emit(selected)
#
#
#func _make_exclusive():
#	if not exclusive:
#		return
#	get_tree().call_group("selected", "set_selected", false)
#
#func _input_event(viewport, event, shape_idx):
#	if event.is_action_pressed("click"):
#		set_selected(not selected)
