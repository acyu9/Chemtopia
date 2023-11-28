extends Node

#const sample = {'Na' : ['Cl', 1], 'Ca' : ['Cl', 2], 'Ba' : ['O', 1]}
# How far to fan the cards - anything pass 50.0 makes the odd animation obvious
const HAND_WIDTH: float = 60.0
const HAND_HEIGHT: float = 15
const ANGLE_SPREAD: float = 1.5

@export var spread_curve: Curve
@export var height_curve: Curve
@export var rotation_curve: Curve

# load the card template and the cards in player's hand
@onready var card_base = preload("res://cards/card_base.tscn")
#@onready var deck_size = sample.size()

# Around the bottom center of screen; can adjust
@onready var center = get_viewport().get_visible_rect().size / 3

# Where the cards are
@onready var card_base_position = center + Vector2(-50, 60)

#signal card_drawn

var num_cards_in_hand = 0
var card_selected = {}
var formula: String = ""

# for setting card background color
var palette: Dictionary = {
	"M": "72dcbb",
	"N": "ab5675",
	"T": "ffe07e",
	"I": "34acba",
	"C": "ffa7a5",
	"D": "ee6a7c"
}

#func _ready():
#	randomize()


func generate_card(deck):
	# make a copy of the card base
	var new_card = card_base.instantiate()
	
	num_cards_in_hand += 1
	
	# set the card to bottom center of screen
	new_card.position = center

	# change the pivset offset (point of rotation) to bottom of card
	new_card.set_pivot_offset(new_card.size /2)

	# scale down the size of the card to fit the viewport better
	new_card.scale /= 2.5

	# null means it's a reactant card, not product card
	update_card(new_card, null, deck)
	
	return new_card


func update_card(new_card, product, deck):
	# global data
	var cards_data = ReactionsData.cards

	# set reactant or product formula
	if product != null:
		formula = product
	else:
		# draw and remove card from deck
		formula = deck.pop_front()

	# update formula
	var symbol_label = new_card.get_node("Symbol/SymbolLabel")
	var formatted_formula = format_subscript(formula)
	symbol_label.text = formatted_formula
	
	# update name
	var chem_name = new_card.get_node("Name/NameLabel") 
	if cards_data[formula]["Name"] == null:
		cards_data[formula]["Name"] = "null"
	chem_name.text = cards_data[formula]["Name"]
#
	# update category
	var category = new_card.get_node("Category/CategoryLabel")
	if cards_data[formula]["Category"] == null:
		cards_data[formula]["Category"] = "null"
	category.text = cards_data[formula]["Category"]

	# update info
	if cards_data[formula]["Info"] == null:
		cards_data[formula]["Info"] = "null"
	var info = new_card.get_node("Info/InfoLabel")
	info.text = cards_data[formula]["Info"]

	# update description
	if cards_data[formula]["Description"] == null:
		cards_data[formula]["Description"] = "To be filled..."
	var description = new_card.get_node("Description/DescriptionLabel")
	description.text = cards_data[formula]["Description"]
	
	card_color(new_card)


func format_subscript(chem_formula):
	var formatted_formula = ""
	var subscript2 = null

	for charac in chem_formula:
		if charac.is_valid_int() and int(charac) >= 1 and int(charac) <= 20:
			subscript2 = "[font_size=18] %s [/font_size]" % charac
			formatted_formula += subscript2
		else:
			formatted_formula += charac
	formatted_formula = "[center] %s [/center]" % formatted_formula
	return formatted_formula


func card_color(card):
	var category_label = card.get_node("Category/CategoryLabel")
	var background = card.get_node("Background")
	
	background.modulate = palette[category_label.text]
	
	
	

# fan_cards and update_card_pos are the old fanning methods
# the new method is more spread out so less issue with overlapping cards
#func fan_cards(cards: Control):
#	var cards_in_hand = cards.get_children()
#	var animTime = 1.0
#
#	update_card_pos(cards_in_hand, animTime, center)


#func update_card_pos(cards, animTime, start_pos):
#	for card in cards:
#		# if there's only one card, set it to the center of hand
#		var hand_ratio = 0.5
#
#		var num_cards = float(cards.size())
#
#		if num_cards > 1:
#			hand_ratio = float(card.get_index()) / float(num_cards - 1)
#
#			var position = card.position
#
#			# spreads out the cards horizontally
#			position.x = start_pos.x + spread_curve.sample(hand_ratio) * HAND_WIDTH
#			# spreads out the cards vertically
#			position.y = start_pos.y + height_curve.sample(hand_ratio) * HAND_HEIGHT
#
#			animate_cards("position", card, position, animTime)
#
#			var rotation = rotation_curve.sample(hand_ratio) * ANGLE_SPREAD
#			animate_cards("rotation", card, rotation, animTime)


# Set up tween to play the fan animation --- only used for rotation now
func animate_cards(type, object, to, animTime):
	var tween = get_tree().create_tween()

	tween.tween_property(object, type, to, animTime).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)

	await(get_tree().create_timer(animTime).timeout)
#	tween.queue_free()


# without the curve graph
func fan_cards(cards: Control):
	var cards_in_hand = cards.get_children()

	var num_cards = float(cards.get_children().size())
	var halfSpread = (num_cards - 1) * HAND_WIDTH / 2

	for i in range(num_cards):
		# calculate how far to spread based on number of cards in hand
		var card = cards_in_hand[i]
		
		var targetX = card_base_position.x + i * HAND_WIDTH - halfSpread
		var targetY = card_base_position.y

		if i < num_cards / 2:
			targetY -= i * HAND_HEIGHT
		else:
			targetY -= (num_cards - i - 1) * HAND_HEIGHT

		var position = Vector2(targetX, targetY)
		
		# tween the horizontal and vertical spread
		var tween = get_tree().create_tween()
		tween.tween_property(card, "position", position, 0.2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)

		# rotate the cards so they look like a fan
		var hand_ratio = float(i) / float(num_cards - 1)
		var rotation = rotation_curve.sample(hand_ratio) * ANGLE_SPREAD
		animate_cards("rotation", card, rotation, 0.2)
		

#func zoom_in(card):
#	print('before tween', card.position)
#	# save the card rotation and position before any change
#	original_rotation = card.rotation
#	original_pos = card.position
#	var zoom_in_factor = 0.6
#	original_scale = card.scale
##		print('before tween: ', get_node(".").position)
#
#	# set_parallel lets all the animations to happen at the same time
#	# goes faster so the card doesn't get stuck in the "zoom in" state 
#	# when the mouse moves across the card really fast
#	var tween = card.create_tween().set_parallel(true)
#
#	# rotate the card to face straight
#	tween.tween_property(card, "rotation", 0.0, 0.1).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
#	# move the card up so the whole card is in the screen
#	tween.tween_property(card, "position", original_pos + Vector2(0, -50), 0.1).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)	
#	# zoom in on the card
#	tween.tween_property(card, "scale", Vector2(zoom_in_factor, zoom_in_factor), 0.3).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
#	# bring the card forward
#	get_node(".").z_index = 6
#	await tween.finished
#
#	print('after tween: ', card.position)
#
#
#func zoom_out(card):
#
#	var tween = card.create_tween().set_parallel(true)
#	tween.tween_property(card, "scale", original_scale, 0.3).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
#	get_node(".").z_index = 0
#	tween.tween_property(card, "position", original_pos, 0.1).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)	
#	tween.tween_property(card, "rotation", 0.0, 0.1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
#	await tween.finished



# The original fan card logic
# He used func _process instead of tween though
# Fan card logic
# comments are the pseudocode from the tutorial
#func fan_cards(cards: Node2D):
#	# assume cards = hand.get_children()
#
#	for card in cards.get_children():
#		# if there's only one card, set it to the center of hand
#		var hand_ratio = 0.5
#
##		float(cards.get_children_count()) = total number of cards
#		var num_cards = float(cards.get_child_count())
##
##		if get_child_count() > 1:
## 			var hand_ratio = float(card.get_index()) / float(hand.get_child_count()-1)
#		if num_cards > 1:
#			hand_ratio = float(card.get_index()) / float(num_cards - 1)
##			print(hand_ratio)  # prints 0
#
#			# spreads out the cards horizontally
#			# play around with HAND_WIDTH
#			# use this instead? var position = card.position for the line below
##			var destination := cards.global_transform
#			var position = card.position
##			print(spread_curve.sample(hand_ratio))
##			destination.origin.x += spread_curve.interpolate(hand_ratio) * HAND_WIDTH
##			position.x = spread_curve.sample(hand_ratio) * HAND_WIDTH
#			position.x = spread_curve.sample(hand_ratio) * HAND_WIDTH
#
#
#			# spreads out the cards vertically
#	#		destination.origin.y += height_curve.interpolate(hand_ratio) * Vector2.UP
#			position.y = height_curve.sample(hand_ratio) * HAND_HEIGHT
#
#			card.position = position
#
#			# for rotation
##			card.target_rotation = rotation_curve.interpolate(hand_ratio) * 0.3
#			var rotation = rotation_curve.sample(hand_ratio) * ANGLE_SPREAD
#			card.rotation += rotation

