extends Node2D

@onready var mao_actionable: Area2D = $MaoMao/MaoActionable
@onready var maomao: StaticBody2D = $MaoMao
@onready var animated_sprite = $MaoMao/AnimatedSprite2D

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
#func _process(_delta):
	
	

func _on_house_entrance_body_entered(_body):
	$Chemtopia.visible = false
	$Game_Rules_Button.visible = false
	$Energy.visible = false
	TransitionLayer.change_scene("res://scenes/levels/player_house.tscn")

