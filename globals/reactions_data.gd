extends Node

# can play the game and directly print here since this is made global

var reactions_data

# load json data
var cards: Dictionary
var synthesis_dict: Dictionary
var decomp_dict: Dictionary
var sr_dict: Dictionary
var dr_dict: Dictionary
var combustion_dict: Dictionary

# match reaction type to its dict
var reaction_dict: Dictionary

# for filling out gaps in the cards dict
var positive_one: Array = ["H", "Li", "Na", "K", "Rb", "Cs", "Cu", "Ag"]
var positive_two: Array = ["Be", "Mg", "Ca", "Sr", "Ba", "Cd", "Ni", "Sn", "Zn", "Co"]
var positive_three: Array = ["B", "Al", "Fe"]
var positive_four: Array = ["Pb"]
var negative_one: Array = ["F", "Cl", "Br", "I"]
var negative_two: Array = ["O", "S"]
var negative_three: Array = ["N", "P"]
#var anions: Array = ["fluoride", 'chloride', 'bromide', 'iodide', 'oxide', 'sulfide', 'nitride', 'phosphide']
var anions: Dictionary = {
	"F": "fluoride",
	"Cl": "chloride",
	"Br": "bromide",
	"I": "iodide",
	"O": "oxide",
	"S": "sulfide",
	"N": "nitride",
	"P": "phosphide",
}
var transition_metals: Dictionary = {
	"Cu": 'Copper (I)',
	"Ni": 'Nickel (I)',
	"Sn": 'Tin (I)',
	"Co": 'Cobalt (I)',
	"Fe": 'Iron (III)',
	"Pb": 'Lead (IV)'
}     


# sort cards by reaction type
var synthesis_cards: Array = []
var decomp_cards: Array = []
var sr_cards: Array = []
var dr_cards: Array = []
var combustion_cards: Array = []


func _ready():
	var reactionsdata_file = FileAccess.open("res://data/synthesis.json", FileAccess.READ)
	#reactionsdata_file.open("res://data/reactions.json", File.READ)
	var json = JSON.new()
	json.parse(reactionsdata_file.get_as_text())
	reactionsdata_file.close()
	reactions_data = json.get_data()
	
	# get cards data
	load_cards_json()
	
	# get reactions data
	load_reactions_jsons()
#	print(dr_dict["NH3, Li3P"])

	# fill in nulls in cards dict
	complete_cards_dict()
#	print(cards["Fe2O3"])
	
	# sort the cards into respective reaction type array for random drawing later
	sort_cards()
#	print(sr_dict.size())
#	print(sr_cards.size())

	# set up reaction dict to match reaction type to its dict
	reaction_dict = {
		"synthesis" : synthesis_dict,
		"decomp" : decomp_dict,
		"sr" : sr_dict,
		"dr" : dr_dict,
		"combustion" : combustion_dict
	}
	


func load_cards_json():
	var cards_file = FileAccess.open("res://data/cards.json", FileAccess.READ)
	var json2 = JSON.new()
	json2.parse(cards_file.get_as_text())
	cards_file.close()
	cards = json2.get_data()


func load_reactions_jsons():
	var data = FileAccess.open("res://data/synthesis.json", FileAccess.READ)
	var json = JSON.new()
	json.parse(data.get_as_text())
	data.close()
	synthesis_dict = json.get_data()
	
	data = FileAccess.open("res://data/decomp.json", FileAccess.READ)
	json.parse(data.get_as_text())
	data.close()
	decomp_dict = json.get_data()
	
	data = FileAccess.open("res://data/sr.json", FileAccess.READ)
	json.parse(data.get_as_text())
	data.close()
	sr_dict = json.get_data()
	
	data = FileAccess.open("res://data/dr.json", FileAccess.READ)
	json.parse(data.get_as_text())
	data.close()
	dr_dict = json.get_data()
	
	data = FileAccess.open("res://data/combustion.json", FileAccess.READ)
	json.parse(data.get_as_text())
	data.close()
	combustion_dict = json.get_data()


# fill in name and info (charges or v.e.) for the cards
func complete_cards_dict():
	for key in cards.keys():
		if cards[key]["Name"] == null or cards[key]["Name"] == "":
			cards[key]["Name"] = find_name(key)
		if cards[key]["Info"] == null or cards[key]["Info"] == "":
			cards[key]["Info"] = find_info(cards[key]["Category"], key)


# split a molecule into cation/anion components
func split_key(key):
	var regex = RegEx.new()
	
	# ignores all digits -- can add [0-9] here to account for digits?
	regex.compile('([A-Z][a-z]?)')
	var ions = []
	for result in regex.search_all(key):
		ions.append(result.get_string())
#	print(ions)
	return ions


func find_name(key):
	var ions = split_key(key)
	var chem_name = ""
	var is_transition_metal = false

	for trans_metal in transition_metals.keys():
		if ions[0] in trans_metal:
			chem_name += (transition_metals[trans_metal])
			chem_name += " "
			is_transition_metal = true
			break

	# find the name for cation from the cards dict
	# check if cation is a transition metal first
	if not is_transition_metal:
		for card in cards.keys():
			if ions[0] in card:
				chem_name += (cards[card]["Name"])
				chem_name += " "
				break
	
	# IMPORTANT: cations need to be towards the top of the dict
	# find the name for anion in the anions dict
	for anion in anions.keys():
		if ions[1] in anion:
			chem_name += anions[anion]
			break
	
#	print(name)
	return chem_name


# charges for I and v.e. for C
func find_info(category, key):
	var ions = split_key(key)
	var info = ""
	
	if category == "I":
		if ions[0] in positive_one:
			info += "1+, "
		elif ions[0] in positive_two:
			info += "2+, "
		elif ions[0] in positive_three:
			info += "3+, "
		elif ions[0] in positive_four:
			info += "4+, "
		
		if ions[1] in negative_one:
			info += "1-"
		elif ions[1] in negative_two:
			info += "2-"
		elif ions[1] in negative_three:
			info += "3-"
			
	elif category == "C":
		for i in range(2):
			if ions[i] == "H":
				info += "1"
			elif ions[i] in negative_one:
				info += "7"
			elif ions[i] in negative_two:
				info += "6"
			elif ions[i] in negative_three:
				info += "5"
			
			if i == 0:
				info += ", "
			elif i == 1:
				info += " v.e."
	
#	print(info)
	return info


# sort cards for random draws when creating deck
# the "Reaction Types" only applies to reactants!!!
func sort_cards():
	# don't use elif because a card can be in more than one reaction types
	for key in cards.keys():
		if "Synthesis" in cards[key]["Reaction Types"]:
			synthesis_cards.append(key)
		if "Decomp" in cards[key]["Reaction Types"]:
			decomp_cards.append(key)
		if "SR" in cards[key]["Reaction Types"]:
			sr_cards.append(key)
		if "DR" in cards[key]["Reaction Types"]:
			dr_cards.append(key)
		if "Combustion" in cards[key]["Reaction Types"]:
			combustion_cards.append(key)
	
	# add more oxygen cards for combustion
	for i in range(3):
		combustion_cards.append("O2")



