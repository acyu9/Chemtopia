extends Node2D

#const CardSize = Vector2(125, 175)
const TIMER: float = 2.5

# load the card template and the cards in player's hand
@onready var player_hand = $PlayerHand
@onready var card_base_scene = preload("res://cards/card_base.tscn")
#@onready var deck_size = player_hand.sample.size()
@onready var deck = $Deck
@onready var card_spot = preload("res://cards/card_spot.tscn")

#var center_of_screen = get_viewport_rect().position
@onready var center = get_viewport().get_visible_rect().size / 2

# basic setups
@onready var reaction_data = ReactionsData.reaction_dict[Globals.reaction_type]
var card_base

# for playing cards
var card_spot1
var card_spot2
var left_spot
var right_spot
var target_turn = "player"
var turn = 1
var turn_ended: bool = false
var opponent_turn_ended: bool = false
var game_ended: bool = false
var product_card1
var product_card2
@onready var message = $CenterContainer/VSeparator/EndGameMessage
@onready var player_health = $PlayerHealth.value
@onready var opponent_health = $OpponentHealth.value

# for attack
var zero: bool = true
var damage: int = 0
var products: String = ""
var product1: String = ""
var product2: String = ""

# opponent setup
var opponent_card1 
var opponent_card2


func _ready():
	# set up music based on reaction type
	Globals.location = "card"
	Music.set_music()
	music_setup()
	
	health_sprite()
	
	left_spot = center / 2
	right_spot = center / 2 + Vector2(150, 0)

	card_base = card_base_scene.instantiate()
	setup_card_spot(Globals.reaction_type)
	
	# set up initial deck
	while deck.deck_size > 0 and player_hand.num_cards_in_hand < 6:
		draw_card()
	
	# opponent setup
	
	opponent_card1 = card_base_scene.instantiate()
	card_setup(opponent_card1)
#	self.add_child(opponent_card1)
#	opponent_card1.scale = card_base.scale / 2.5
#	opponent_card1.position = center / 2
#	opponent_card1.visible = false
	
	if Globals.reaction_type != "synthesis":
		
		opponent_card2 = card_base_scene.instantiate()
		card_setup(opponent_card2)
		opponent_card2.position += Vector2(150, 0)
#		self.add_child(opponent_card2)
#		opponent_card2.visible = false
	
	# product cards setup
	product_card1 = card_base_scene.instantiate()
	card_setup(product_card1)
	product_card2 = card_base_scene.instantiate()
	card_setup(product_card2)
	product_card2.position += Vector2(150, 0)


func music_setup():
	if Globals.reaction_type == 'decomp':
		$Music/KidMusic.playing = true
	elif Globals.reaction_type == 'synthesis':
		$Music/Alien1Music.playing = true
	elif Globals.reaction_type == 'sr':
		$Music/GrannyMusic.playing = true
	elif Globals.reaction_type == 'dr':
		$Music/SlimeMusic.playing = true
	elif Globals.reaction_type == 'combustion':
		$Music/ImpMusic.playing = true


func card_setup(card):
	self.add_child(card)
	card.scale = card_base.scale / 2.5
	card.position = center / 2
	card.visible = false
	

func setup_card_spot(reaction_type):
	card_spot1 = card_spot.instantiate()
	card_spot1.scale = card_base.scale / 2.5
	
	if reaction_type == "decomp":
		card_spot1.position = center / 2 + Vector2(75, 0)
	
	# all other reactions have 2 card spots, separated by x-dist of 150s
	if reaction_type != "decomp":
		card_spot1.position = left_spot
		card_spot2 = card_spot.instantiate()
		card_spot2.scale = card_base.scale / 2.5
		card_spot2.position = right_spot
		$CardSpots.add_child(card_spot2)

	$CardSpots.add_child(card_spot1)


# change the opponent sprite based on the reaction type
func health_sprite():
	if Globals.reaction_type == "synthesis":
		$OpponentHealth/Alien1Sprite.visible = true
	elif Globals.reaction_type == "decomp":
		$OpponentHealth/KidSprite.visible = true
	elif Globals.reaction_type == "sr":
		$OpponentHealth/GrannySprite.visible = true
	elif Globals.reaction_type == "dr":
		$OpponentHealth/Alien4Sprite.visible = true
	elif Globals.reaction_type == "combustion":
		$OpponentHealth/Alien5Sprite.visible = true
		

func _process(_delta):
	if turn == 6 or player_health <= 0 or opponent_health <= 0:
		# stops the player and opponent from playing when the game is over
#		target_turn = "player"
		determine_winner()
		$EndTurn/Button.disabled = true
		$Quit/QuitButton.disabled = true
		
		# press any button to switch back to level scene
	
	# draw card when the opponent's turn ended
	elif turn_ended and target_turn == "opponent" and zero:
		opponent_move()
#		target_turn == "player"
		turn_ended = false
		
		# draw cards after opponent's move
		await get_tree().create_timer(TIMER).timeout
	
		# might not need this if statement
		if opponent_turn_ended:
#			target_turn == "player"

			# need to update card_base so can select cards again in player's turn
			Globals.droppable_occupied = false
			Globals.droppable2_occupied = false
			Globals.card_selected = false
			if turn < 6:
				$Turn/Label.text = "Turn " + str(turn)

			while deck.deck_size > 0 and player_hand.num_cards_in_hand < 6:
				draw_card()
			turn_ended = false



func draw_card():
	var new_card = player_hand.generate_card(deck.deck)
#	player_hand.card_color(new_card)

#	print('card', new_card.position)
#	print(new_card.anchors_preset)
#	new_card.set_anchors_preset(8, true)
#	new_card.position = Vector2(272, 153)
#	print('screen', center_of_screen)
#	new_card.position = center_of_screen

#	new_card.get_card_spot(card_spot1.position, card_spot2.position)
	if Globals.reaction_type == "decomp":
		new_card.get_card_spot(center / 2 + Vector2(75, 0), right_spot)
	else:
		new_card.get_card_spot(left_spot, right_spot)
	
	# add the card to Cards node
	$Cards.add_child(new_card)
	
	# Update number of cards left in the deck
	deck.update_card_count_text()
	
	player_hand.fan_cards($Cards)


func _on_button_pressed():
	# blocks end turn button from registering when just zooming in on cards
	if not Input.is_action_just_released("click"):
		$CanvasLayer/Button.button_pressed = false
		return
		
	# check if any card spot is empty. if so, don't attack and just switch turn
	if Globals.card1 == null and Globals.card2 == null:
		print('both are null')
		update_player_hand()
		damage = 0
		target_turn = "opponent"
		turn_ended = true
		return
	elif Globals.card1 == null and Globals.reaction_type != "decomp":
		print('1 is null')
#		$Cards.remove_child($Cards.get_node(str(Globals.card2)))
		update_player_hand()
		damage = 0
		target_turn = "opponent"
		turn_ended = true
		return
	elif Globals.card2 == null and Globals.reaction_type != "decomp":
		print('2 is null')
#		$Cards.remove_child($Cards.get_node(str(Globals.card1)))
		update_player_hand()
		damage = 0
		target_turn = "opponent"
		turn_ended = true
		return
		
	find_product()
	
#	print(Globals.card1.position)
#	Globals.card1.position = Vector2(0,0)
#	print(Globals.card1.position)
#	await get_tree().create_timer(5).timeout
	
	# no product was created so zero attack animation & go to opponent's turn
	if turn_ended:
		zero = false
		zero_dmg_animation(Globals.card1)
		zero_dmg_animation(Globals.card2)
		await get_tree().create_timer(TIMER).timeout
		update_player_hand()
		zero = true
		return
	
	zero = true
	update_player_hand()

	generate_product_card(product_card1, product_card2)
	
	product_card1.visible = true
	if Globals.reaction_type != "synthesis":
#		player_hand.card_color(product_card2)
		product_card2.visible = true
		
	target_turn = "player"
	update_health(target_turn)

	attack()

	# wait time in between player and opponent turns
	await get_tree().create_timer(TIMER).timeout

	target_turn = "opponent"
	turn_ended = true


# search through reaction dict to find the product(s) and damage dealt
func find_product():
	var card1 = Globals.card1.get_node("Symbol/SymbolLabel")
	var reactant1 = card1.text
	var reactant2
	
	# remove BBCode for formatting label text
	reactant1 = reactant1.lstrip("[center]").rstrip("[/center]")
	reactant1 = reactant1.replace("[font_size=18]", "").replace("[/font_size]", "").replace(" ", "")
	
	if Globals.reaction_type != "decomp":
		var card2 = Globals.card2.get_node("Symbol/SymbolLabel")
		reactant2 = card2.text
		reactant2 = reactant2.lstrip("[center]").rstrip("[/center]")
		reactant2 = reactant2.replace("[font_size=18]", "").replace("[/font_size]", "").replace(" ", "")

	var product_found = false

	# use the reactants to find the product in the reaction dict
	for reaction_key in reaction_data.keys():
#		if Globals.reaction_type != "decomp" and reactant1 in reaction_key and reactant2 in reaction_key:
		if (
			reactant1 in reaction_key and
			(Globals.reaction_type == "decomp" or reactant2 in reaction_key)
			and reactant1 != reactant2
		):
			products = reaction_data[reaction_key]["Products"]
			damage = reaction_data[reaction_key]["Coefficient"]
			product_found = true
		# reaction didn't occur, directly end the player's turn

	if not product_found:
		products = ""
		damage = 0
		target_turn = "opponent"
		turn_ended = true



# remove reactants cards
func update_player_hand():
	var to_remove
#	print($Cards.get_child_count())
	if Globals.card1 != null:
		to_remove = $Cards.get_node(str(Globals.card1))
	#	to_remove.queue_free()
		Globals.card1 = null
		$Cards.remove_child(to_remove)
	
	if Globals.card2 != null:
		to_remove = $Cards.get_node(str(Globals.card2))
#	to_remove.queue_free()
		Globals.card2 = null
		$Cards.remove_child(to_remove)
	
	# update number of cards in player hand
	player_hand.num_cards_in_hand = $Cards.get_child_count()
#	print(player_hand.num_cards_in_hand)


# create products cards
func generate_product_card(card1, card2):
	format_products()
	
	player_hand.update_card(card1, product1, deck.deck)
#	player_hand.card_color(card1)
	if product2 != "" and Globals.reaction_type != "synthesis":
		player_hand.update_card(card2, product2, deck.deck)
#		player_hand.card_color(card2)
	

# split products if there's more than 1
func format_products():
	if Globals.reaction_type == "synthesis":
		product1 = products
	else:
		product1 = products.get_slice(", ", 0)
		product2 = products.get_slice(", ", 1)


func zero_dmg_animation(card):
	var tween = get_tree().create_tween()
	tween.tween_property(card, "rotation", 1, 0.2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	tween.tween_property(card, "rotation", -1, 0.2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	tween.tween_property(card, "rotation", 0, 0.2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	await tween.finished
	


func attack_animation(card):
	var start_pos = card.position
	var end_pos
	if target_turn == "player":
		end_pos = start_pos + Vector2(0, -50)
	else:
		end_pos = start_pos + Vector2(0, 50)
	var tween = get_tree().create_tween()
	tween.tween_property(card, "position", end_pos, 0.3).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	$Camera2D.apply_shake()
	tween.tween_property(card, "position", start_pos, 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	

func attack():
	if target_turn == "player":
		attack_animation(product_card1)
		if Globals.reaction_type != "synthesis":
			attack_animation(product_card2)
		$AttackOpponent.text = "-" + str(damage)
	else:
		attack_animation(opponent_card1)
		if Globals.reaction_type != "synthesis":
			attack_animation(opponent_card2)
		$AttackPlayer.text = "-" + str(damage)
	
	await get_tree().create_timer(TIMER).timeout
	
	# after attack, hide the product card
	product_card1.visible = false
	
#	await get_tree().create_timer(2.0).timeout
	opponent_card1.visible = false
	
	if Globals.reaction_type != "synthesis":
		product_card2.visible = false
		opponent_card2.visible = false
	
	if $AttackOpponent.text != "":
		$AttackOpponent.text = ""
	elif $AttackPlayer.text != "":
		$AttackPlayer.text = ""
	
	await get_tree().create_timer(2.0).timeout
	
	
# need to call this somewhere
func switch_turn(switch_off):
	$CanvasLayer/Button.disabled = switch_off


# update health value and UI for both opponent and player
func update_health(attacker):
	if attacker == "player":
		opponent_health -= damage
		$OpponentHealth.value = opponent_health
	else:
		player_health -= damage
		$PlayerHealth.value = player_health


func opponent_move():
	# randomly select product from synthesis reaction data
	# if it's attack power of 8 or a card already played then reselect
	var cards_played: Array = []
	var products_chosen: bool = false
	var random_key
	
	while not products_chosen:
#		random_key = ReactionsData.synthesis_dict.keys()[randi() % ReactionsData.synthesis_dict.size()]
		random_key = reaction_data.keys()[randi() % reaction_data.size()]

		# limit attack power to less than 5 - can change based on reaction type
		if random_key not in cards_played and reaction_data[random_key]["Coefficient"] < 5:
			cards_played.append(random_key)
			products_chosen = true
		
	products = reaction_data[random_key]["Products"]
	damage = reaction_data[random_key]["Coefficient"]

	# format the products
	generate_product_card(opponent_card1, opponent_card2)
	opponent_card1.visible = true
	
	if Globals.reaction_type != "synthesis":
		opponent_card2.visible = true

	update_health(target_turn)
	attack()

	opponent_turn_ended = true
	turn += 1


# after a certain number of rounds, calculate who the winner is
func determine_winner():
	if player_health > opponent_health:
		message.text = "On the right track!"
	elif player_health < opponent_health:
		message.text = "Int +1!"
	else:
		message.text = "Improving together!"
	
	game_ended = true
	$CenterContainer/VSeparator/Direction.visible = true


# switch scene when the game is over
func _unhandled_key_input(event):
	if event.is_pressed() and game_ended:
		Globals.game_count[Globals.reaction_type] += 1
		Globals.game_count["total"] += 1
		leave_card_game()


# quit game & transition back to level scene
func leave_card_game():
	# reset variables
	Globals.card_selected = false
	Globals.droppable_occupied = false
	Globals.droppable2_occupied = false
	Globals.energy -= 1
	Globals.show_icons = true
	if Globals.reaction_type == "sr" or Globals.reaction_type == "dr":
		TransitionLayer.change_scene("res://scenes/levels/diner.tscn")
	else:
		TransitionLayer.change_scene("res://scenes/levels/outside.tscn")


# leave card game when quit button is pressed
func _on_quit_button_pressed():
	leave_card_game()
