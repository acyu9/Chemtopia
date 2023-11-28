extends RichTextLabel


#var sample = {'Na' : ['Cl', 1]}
#
#func _ready():
#	#print(symbol_label.text)
#	var Na = sample.keys()[0]
#	var Cl = sample.get(Na)[0]
#	var subscript = sample.get(Na)[1]
#
#	var symbol_text = Na + Cl + '[font_size=10] %s [/font_size]' % [str(subscript)]
#
#	# 1 is subscript, though not the best formatting
#	append_text('[center]%s[/center]' % symbol_text)

#func update_symbol_label(card_info):
##	print(card_info)
#	var Na = card_info.keys()[0]
#	var Cl = card_info.get(Na)[0]
#	var subscript = card_info.get(Na)[1]
#
#	var symbol_text = Na + Cl + '[font_size=10] %s [/font_size]' % [str(subscript)]
#
#	# USE THIS INSTEAD!!!
#	# can directly get the card dict key for the function's parameter!
##	var formula_text = format_subscript("H2O2")
#
#	# 1 is subscript, though not the best formatting
#	append_text('[center]%s[/center]' % symbol_text)
#
#
#func format_subscript(formula):
##	var s = "H2O"
#	var formatted_formula = ""
#	var subscript2 = null
#
#	for charac in formula:
#		if charac.is_valid_int() and int(charac) >= 1 and int(charac) <= 4:
#			subscript2 = "[font_size=10] %s [/font_size]" % charac
#			formatted_formula += subscript2
#		else:
#			formatted_formula += charac
#	return formatted_formula
