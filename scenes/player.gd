extends CharacterBody2D

var speed: int = 150
var direction: Vector2 = Vector2.ZERO

@onready var animation_tree: AnimationTree = $AnimationTree
@onready var actionable_finder: Area2D = $Direction/ActionableFinder



#func _ready():
#	position = Globals.player_pos
##	animation_tree.active = true
#	$AnimatedSprite2D.play("idle_down")


# _unhandled_input is so menus and such can block/prevent input. 
# don't won't the character to move or do stuff while a menu is open/overlayed.
func _unhandled_input(_event: InputEvent) -> void:
	# when space bar is pressed, not continuous even holding down the space bar
	if Input.is_action_just_pressed("interact"):
		var actionables = actionable_finder.get_overlapping_areas()
		if actionables.size() > 0:
			actionables[0].action()
			# don't save position if talking to MaoMao
			if "MaoActionable" not in str(actionables):
				# for saving player pos before card game (outside vs diner)
				if "Alien3Actionable" not in str(actionables) and "Alien4Actionable" not in str(actionables):
					Globals.player_pos = position
				else:
					Globals.diner_pos = position
			
			
			
#func _process(_delta):
func _physics_process(_delta):
	if Input.is_action_pressed("right"):
		$AnimatedSprite2D.play("run_right")
		$Direction.rotation = -90
	elif Input.is_action_pressed("down"):
		$AnimatedSprite2D.play("run_down")
		$Direction.rotation = 0
	elif Input.is_action_pressed("up"):
		$AnimatedSprite2D.play("run_up")
		$Direction.rotation = 180
	elif Input.is_action_pressed("left"):
		$AnimatedSprite2D.play("run_left")
		$Direction.rotation = 90

	if Input.is_action_just_released("right"):
		$AnimatedSprite2D.play("idle_right")
	elif Input.is_action_just_released("down"):
		$AnimatedSprite2D.play("idle_down")
	elif Input.is_action_just_released("up"):
		$AnimatedSprite2D.play("idle_up")
	elif Input.is_action_just_released("left"):
		$AnimatedSprite2D.play("idle_left")
	
	
	
	
#	update_animation()
#
##func _physics_process(_delta):
	# movement input
	direction = Input.get_vector('left', 'right', 'up', 'down').normalized()

	if direction:
		velocity = direction * speed
	else:
		velocity = Vector2.ZERO

	# automatically includes delta
	move_and_slide()
#
#func update_animation():
#	# if Player is idle and not moving
#	if(velocity == Vector2.ZERO):
#		animation_tree["parameters/conditions/is_idle"] = true
#		animation_tree["parameters/conditions/is_moving"] = false
#		$IdleSprite.visible = true
#		$RunSprite.visible = false
#	else:
#		animation_tree["parameters/conditions/is_idle"] = false
#		animation_tree["parameters/conditions/is_moving"] = true
#		$IdleSprite.visible = false
#		$RunSprite.visible = true
#
#	# if not the default direction (0, 0)
#	if(direction != Vector2.ZERO):
#		# If movement is diagonal, just change to up or down
#		if(Input.is_action_pressed("down") and Input.is_action_pressed("right")):
#			direction = Vector2(0, 1.1)
#		elif(Input.is_action_pressed("down") and Input.is_action_pressed("left")):
#			direction = Vector2(0, 1.1)
#		elif(Input.is_action_pressed("up") and Input.is_action_pressed("right")):
#			direction = Vector2(0, -1.1)
#		elif(Input.is_action_pressed("up") and Input.is_action_pressed("left")):
#			direction = Vector2(0, -1.1)
#
#		animation_tree["parameters/Idle/blend_position"] = direction
#		animation_tree["parameters/Run/blend_position"] = direction

