extends CanvasLayer
#extends Control
#extends Node2D

var data
var parse_result


func _on_save_pressed():
	save_game()


func _on_load_pressed():
	load_game()


# not supported for HTML game so button disabled for now
func _on_quit_pressed():
	get_tree().quit()


# need to add in other NPCs' dialogues
func save_file():
	# process current scene text, e.g. Outside becomes outside
	var scene = str(get_tree().get_current_scene())
	scene = scene.split(":")[0]
	scene = scene.to_lower()
	if scene == "playerhouse":
		scene = "player_house"
	
	# get player's current position
	var player_pos = get_parent().get_node("Player").position
	
	var save_dict = {
		"current scene" : scene,
		"position" : [player_pos.x, player_pos.y],
		"game count" : Globals.game_count,
		"energy" : Globals.energy,
		"intro" : Globals.intro,
		"maomao" : Globals.maomao_dialogue,
		"alien1" : Globals.alien1_dialogue,
		"kid" : Globals.kid_dialogue
	}
	return save_dict


# create save json file and write the save dict to it
func save_game():
#	var save = FileAccess.open("user://savefile.save", FileAccess.WRITE)
	var save = FileAccess.open_encrypted_with_pass("user://savefile.save", FileAccess.WRITE, "kiddos")
	
	var json_string = JSON.stringify(save_file())
	
	save.store_line(json_string)
	save.close()


func load_game():
	# don't do anything if save file doesn't exist
	if not FileAccess.file_exists("user://savefile.save"):
		return
	
#	var save = FileAccess.open("user://savefile.save", FileAccess.READ)
	var save = FileAccess.open_encrypted_with_pass("user://savefile.save", FileAccess.READ, "kiddos")
	
	while save.get_position() < save.get_length():
		var json_string = save.get_line()
		var json = JSON.new()
		parse_result = json.parse(json_string)
		data = json.get_data()
	
	save.close()

	# simulate "esc" pressed to close the menu; otherwise, animation won't load
	Input.action_press("menu")

	var scene_path = "res://scenes/levels/%s.tscn" % data["current scene"]
	TransitionLayer.change_scene(scene_path)

	# TODO: add other NPCs dialogue progress
	# TODO: save player pos for other maps too. See below
	# only update player position if outside b/c other maps use different
	# Globals variables to keep track of player pos for transitioning scenes
	if data["current scene"] == "outside":
		Globals.player_pos = Vector2(data["position"][0], data["position"][1])
	Globals.game_count = data["game count"]
	Globals.energy = data["energy"]
	Globals.intro = data["intro"]
	Globals.maomao_dialogue = data["maomao"]
	Globals.alien1_dialogue = data["alien1"]
	Globals.kid_dialogue = data["kid"]
