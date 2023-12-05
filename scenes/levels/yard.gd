extends Node2D

@onready var mao_actionable: Area2D = $MaoMao/MaoActionable
@onready var maomao: StaticBody2D = $MaoMao
@onready var animated_sprite = $MaoMao/AnimatedSprite2D
@onready var pause_menu = $PauseMenu
var paused: bool = false


# Use ready so the dialogue only plays once
func _ready():
	
	if Globals.intro == "start":
		#animated_sprite.play("idle")
		mao_actionable.action()
	else:
		# remove the node when plot is done
		maomao.free()
	
	if Globals.intro != "" and Globals.intro != "ended" and Globals.intro != "start":
		$Chemtopia.visible = true
		$Game_Rules_Button.visible = true
		$Energy.visible = true


func _process(_delta):
	if Input.is_action_just_pressed("menu"):
		pause()


# pause the game with the pause menu
func pause():
	paused = !paused
	
	if paused:
		pause_menu.show()
		Engine.time_scale = 0
	else:
		pause_menu.hide()
		Engine.time_scale = 1
	
	

func _on_house_entrance_body_entered(_body):
	$Chemtopia.visible = false
	$Game_Rules_Button.visible = false
	$Energy.visible = false
	TransitionLayer.change_scene("res://scenes/levels/player_house.tscn")

