extends Control

# access the global reactions data dictionary
@onready var card_data = ReactionsData.reactions_data
#var reactant_key = "Na, F2"
#@onready var products = card_data.get(reactant_key).get("Products")

# scale changed to 0.4 on game board
var original_scale = get_node(".").scale / 2.5
var zoom_in_factor = 0.6
var original_rotation = 0
#@onready var original_pos = get_node(".").position
var original_pos = Vector2.ZERO

# select and drop card in droppable card_spot
var body_ref
var offset: Vector2
var card_spot1
var card_spot2
var played_card1
var played_card2

#var zoomed_in = false 
#var animation_playing = false
var zoomed_in = false


# turn on/off property to allow object to be picked
func toggle_pickable(pickable):
	var cards = get_tree().get_nodes_in_group("not_selected")
	for card in cards:
		card.find_child("CardArea2D").input_pickable = pickable


# get the updated card_spot_position from game_board
func get_card_spot(card_spot1_pos, card_spot2_pos):
	card_spot1 = card_spot1_pos
	card_spot2 = card_spot2_pos



# select card and place it in the card spot
func _input(_event):
	if (not Globals.droppable_occupied or not Globals.droppable2_occupied) \
	and Globals.selected_card == self:
#		print(Globals.droppable_occupied)
		if Input.is_action_just_released("click"):
			# can only select one reactant card for decomp
			if Globals.reaction_type == "decomp" and Globals.droppable_occupied:
				return
#			animation_playing = true
			Globals.card_played = self
			self.pivot_offset = Vector2.ZERO
			var tween = get_tree().create_tween()
			# place card in spot1 first if it's empty
			if not Globals.droppable_occupied:
				tween.tween_property(self, "position", card_spot1,0.5).set_ease(Tween.EASE_OUT)
				Globals.card1 = self
				Globals.droppable_occupied = true
			elif not Globals.droppable2_occupied and Globals.droppable_occupied and Globals.card1 != self:
				Globals.droppable2_occupied = true
				tween.tween_property(self, "position", card_spot2,0.5).set_ease(Tween.EASE_OUT)
				Globals.card2 = self
			tween.tween_property(self, "rotation", 0.0, 0.1).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
			await tween.finished
#			animation_playing = false

		# mechanics is less smooth this way but
		# zoom in/out and moving card to card spot won't fight & overlap
		elif Input.is_action_just_pressed("interact") and not zoomed_in:
			zoom_in()
			zoomed_in = true
		elif Input.is_action_just_pressed("interact") and zoomed_in:
			zoom_out()
			zoomed_in = false



# zoom in/out animation when mouse hovers over the card
func zoom_in():
	self.find_child("CardArea2D").monitoring = false
	# save the card rotation and position before any change
	original_rotation = get_node(".").rotation
	original_pos = self.position

	# set_parallel lets all the animations to happen at the same time
	# goes faster so the card doesn't get stuck in the "zoom in" state 
	# when the mouse moves across the card really fast
	var tween = get_tree().create_tween().set_parallel(true)
	
	# rotate the card to face straight
	tween.tween_property(self, "rotation", 0.0, 0.1).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
	# move the card up so the whole card is in the screen
	tween.tween_property(self, "position", original_pos + Vector2(0, -85), 0.1).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)	
	# zoom in on the card
	tween.tween_property(self, "scale", Vector2(zoom_in_factor, zoom_in_factor), 0.3).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	# bring the card forward
	get_node(".").z_index = 6
	await tween.finished



func zoom_out():
	self.find_child("CardArea2D").monitoring = false
	var tween = get_tree().create_tween().set_parallel(true)
	tween.tween_property(self, "scale", original_scale, 0.3).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	get_node(".").z_index = 0
	tween.tween_property(self, "position", original_pos, 0.1).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)	
	tween.tween_property(self, "rotation", original_rotation, 0.1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	await tween.finished
	self.find_child("CardArea2D").monitoring = true
	

# zoom in when mouse enters and prepares for a click if detected
func _on_area_2d_mouse_entered():
	########## try button or textureRect or some other node
	###### instead of area2D to avoid fast signal from mouse hovering?
#	if animation_playing:
#		return


	# if no card is selected, select the current card and make all the other 
	# cards not pickable.
	# if a card is selected, then don't do anything
	if not Globals.card_selected:
		self.find_child("CardArea2D").monitoring = false
		Globals.card_selected = true
		Globals.selected_card = self
		self.remove_from_group("not_selected")
		get_tree().call_group("not_selected", "toggle_pickable", false)
#		zoom_in()
		if not zoomed_in:
			scale = original_scale * 1.05
	else:
		return


# done with the selected card so return everything back to default state
func _on_area_2d_mouse_exited():
#	if animation_playing:
#		return
#	zoom_out()

	if Globals.card_selected and Globals.selected_card == self:
		self.find_child("CardArea2D").monitoring = true
		Globals.card_selected = false
		Globals.selected_card = null
		self.add_to_group("not_selected")
		get_tree().call_group("not_selected", "toggle_pickable", true)
		if not zoomed_in:
			scale = original_scale
	else:
		return

# body is the droppable instance
# only react to the card played, not cards just zooming in and touching the card spot
func _on_area_2d_body_entered(body:StaticBody2D):
	if body.is_in_group('droppable') and Globals.card_played == self:
#		Globals.droppable_occupied = true
#		body.modulate = Color(Color.ANTIQUE_WHITE, 1)
		body_ref = body


func _on_area_2d_body_exited(body:StaticBody2D):
	if body.is_in_group('droppable') and Globals.card_played == self:
		Globals.card_played = null
#		Globals.droppable_occupied = false

		########## more for drag/drop effect
#		body.modulate = Color(Color.ANTIQUE_WHITE, 0.0)
	
	
	


# from the 3D fan tutorial
#func _process(delta: float) -> void:
#		transform = transform.sphere_interpolate_with(target_transform, ANIM_SPEED * delta)
#		rotation.z = lerp(rotation.z, target_rotation, ANIM_SPEED * delta)


