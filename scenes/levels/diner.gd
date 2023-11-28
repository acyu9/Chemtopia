extends Node2D

signal player_entered_diner(body)


# load player position next to NPC
func _ready():
	Globals.location = "outside"
	Music.set_music()
	$Player.position = Globals.diner_pos
	$Chemtopia.visible = true
	$Game_Rules_Button.visible = true
	$Energy.visible = true


func _on_area_2d_body_entered(body):
	player_entered_diner.emit(body)


# diner to outside
func _on_diner_entrance_body_entered(_body):
	# save diner entrance position
	Globals.diner_pos = Vector2(0, 113)
	$Chemtopia.visible = false
	$Game_Rules_Button.visible = false
	$Energy.visible = false
	TransitionLayer.change_scene("res://scenes/levels/outside.tscn")
