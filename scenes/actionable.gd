extends Area2D

# This is the customized balloon, instead of the default sample one
const Balloon = preload("res://dialogues/balloon.tscn")

@export var dialogue_resource: DialogueResource
@export var dialogue_start: String = "start"

func action() -> void:
#	DialogueManager.show_example_dialogue_balloon(dialogue_resource,dialogue_start)
	var balloon: Node = Balloon.instantiate()
	get_tree().current_scene.add_child(balloon)
	balloon.start(dialogue_resource, dialogue_start)
