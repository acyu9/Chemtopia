extends Node2D

@onready var townsfolk: Area2D = $TownsfolkEntrance/EntranceActionable
#@onready var player = preload("res://cards/card_base.tscn")


func _ready():
	Globals.location = "outside"
	Music.set_music()
	
	# only show the icons/features when not transitioning scenes
	$Chemtopia.visible = true
	$Game_Rules_Button.visible = true
	$Energy.visible = true
	$Player.position = Globals.player_pos


func _process(_delta):
	if not Globals.show_icons:
		$Chemtopia.visible = false
		$Game_Rules_Button.visible = false
		$Energy.visible = false
	if Globals.energy == 0:
		$Night.visible = true
	else:
		$Night.visible = false


# Can have own signal by right-clicking the signal...
func _on_house_entrance_body_entered(_body):
	Globals.player_pos = $Player.position + Vector2(0, 10)
	$Chemtopia.visible = false
	$Game_Rules_Button.visible = false
	$Energy.visible = false
	TransitionLayer.change_scene("res://scenes/levels/player_house.tscn")


func _on_diner_entrance_body_entered(_body):
	Globals.player_pos = $Player.position + Vector2(0, 10)
	$Chemtopia.visible = false
	$Game_Rules_Button.visible = false
	$Energy.visible = false
	TransitionLayer.change_scene("res://scenes/levels/diner.tscn")


# set the dialogue for not wanting to talk to townsfolk
func _on_entrance_actionable_body_entered(_body):
	townsfolk.action()


func _on_townsfolk_exit_body_entered(_body):
	townsfolk.action()
