extends Node2D

# attach actionable instance to the original HouseEntrance Area2D so CollisionShape not needed
# actionable Area2D's body_entered signal doesn't fire, because it's an
# instance without a collision shape?
@onready var house_entrance: Area2D = $HouseEntrance/EntranceActionable
@onready var parents_room: Area2D = $ParentsRoom/ParentsActionable
@onready var pause_menu = $PauseMenu
var rest: bool = false
var paused: bool = false


func _ready():
	Globals.location = "house"
	Music.set_music()
	
	if Globals.intro != "" and Globals.intro != "start":
		$MaoMao.visible = true
	
	# player first scene dialogue
	if Globals.intro == "":
		$Player/Actionable.action()
	
	# maomao explains the rules then get rid of that node so only shows greet after
	if Globals.intro == "ended":
		$MaoMao/MaoActionable.action()
		$MaoMao/MaoActionable.queue_free()

	if Globals.intro != "" and Globals.intro != "ended":
		$Player.position = Globals.house_pos


func _process(_delta):
	if Globals.intro == "game_rules":
		$Chemtopia.visible = true
		$Game_Rules_Button.visible = true
		$Energy.visible = true

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


# from inside house to outside
func _on_area_2d_body_entered(_body):
	if Globals.intro == "":
		house_entrance.action()
	else:
		$Chemtopia.visible = false
		$Game_Rules_Button.visible = false
		$Energy.visible = false
		Globals.house_pos = $Player.position + Vector2(0, -10)
		TransitionLayer.change_scene("res://scenes/levels/outside.tscn")


# from inside house to yard
func _on_yard_entrance_body_entered(_body):
	# change global var intro to "start" if it's not "" or "ended"
	if Globals.intro == "":
		Globals.intro = "start"
	$Chemtopia.visible = false
	$Game_Rules_Button.visible = false
	$Energy.visible = false
	Globals.house_pos = $Player.position + Vector2(0, 10)
	TransitionLayer.change_scene("res://scenes/levels/yard.tscn")


# StaticBody2D gives the collision to prevent player from going into the room
func _on_parents_room_body_entered(_body):
	parents_room.action()


# end day when interact with bed
func _unhandled_input(_event):
	if Input.is_action_pressed("interact") and rest:
		TransitionLayer.change_scene("")
		rest = false
		Globals.energy = 3


# when approach bed
func _on_bed_body_shape_entered(_body_rid, _body, _body_shape_index, _local_shape_index):
	rest = true
	
