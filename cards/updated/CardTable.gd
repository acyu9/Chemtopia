extends Node2D


#const CardSize = Vector2(125, 175)

# sample dictionary for trying the random dict element
# var sample = {'Na' : ['Cl', 1], 'Ca' : ['Cl', 2], 'Ba' : ['O', 1]}
#var card_selected = {}

# load the card template and the cards in player's hand
@onready var player_hand = preload("res://cards/player_hand.gd")
@onready var card_base = preload("res://cards/card_base.tscn")
@onready var deck_size = player_hand.sample.size()
@onready var deck = $Deck

#signal card_drawn


#func _ready():
##	print(player_hand.sample)
#	draw_card()

func _input(_event):
	if Input.is_action_just_pressed("interact"):
		draw_card()


func draw_card():
	# make a copy of the card base
	var new_card = card_base.instantiate()
	
	# scale down the size of the card to fit the viewport better
	new_card.scale /= 2.5

	# Using dict now to follow the cards dict format but can change later
	# based on what I end up using for update_symbol_label
	var card_selected = {}
	
	# randomly draw a card from the deck
	var random_key = player_hand.sample.keys()[randi() % deck_size]
	card_selected[random_key] = player_hand.sample[random_key]

	# update the card info
	var symbol_label = new_card.get_node("CenterContainer/SymbolLabel")
	symbol_label.update_symbol_label(card_selected)

	# add the card to Cards node
	$Cards.add_child(new_card)
	
	# Update number of cards left in the deck
	deck.update_card_count_text()
