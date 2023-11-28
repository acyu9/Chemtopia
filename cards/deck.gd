extends Control

var deck_size: int = 20
var deck: Array = []
var card: String = ""

@onready var deck_size_label: Label = $CardCountCircle/CardCount

# Can use func _ready() to set the initial deck size
# helpful if have different starting values
# otherwise just set it directly in Inspector for the label node

func _ready():
	create_deck()


func create_deck():
	for i in range(deck_size):
		if Globals.reaction_type == "synthesis":
			card = ReactionsData.synthesis_cards[randi() % ReactionsData.synthesis_cards.size()]
		elif Globals.reaction_type == "decomp":
			card = ReactionsData.decomp_cards[randi() % ReactionsData.decomp_cards.size()]
		elif Globals.reaction_type == "sr":
			card = ReactionsData.sr_cards[randi() % ReactionsData.sr_cards.size()]
		elif Globals.reaction_type == "dr":
			card = ReactionsData.dr_cards[randi() % ReactionsData.dr_cards.size()]
		elif Globals.reaction_type == "combustion":
			card = ReactionsData.combustion_cards[randi() % ReactionsData.combustion_cards.size()]
		
		deck.append(card)


func update_card_count_text():
	if deck_size > 0:
		deck_size -= 1
		deck_size_label.text = str(deck_size)


# There should be 2 parts to this script

# 1. Grab all the available cards collected (probably from globals data struct)
# make a copy so don't accidentally change the global deck

# 2. Update the number of cards left in the deck as card is drawn

# 2.5 Use slice39 circle to contain the label for the numbers?

# 3. Update the number displayed (see grenade code in Shooter Game)

# 4. Change the size of the deck sprite -- just a small sprite for it

# 5. Change the sprite? It's so ugly lol
