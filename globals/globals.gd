extends Node

# where the player is
var location: String = ""

# save player position before changing scene
var player_pos: Vector2 = Vector2(-165, -62)
var diner_pos: Vector2 = Vector2(0, 113)
var house_pos: Vector2 = Vector2(173, -133)

# energy hearts
var energy: int = 3

# for blocking icons
var show_icons = true

# default animation unless changed elsewhere
var maomao_animation: String = "idle"
var alien1_animation: String = "idle"
var kid_animation: String = "idle"

# controls intro plot
# "" = haven't started, "start" = start the plot, "ended" = done with the plot
var intro: String = ""
var maomao_dialogue = ""
var alien1_dialogue = ""
var kid_dialogue = ""

# keeps track of the card games
var game_count: Dictionary = {
	"synthesis": 0,
	"decomp": 0,
	"sr": 0,
	"dr": 0,
	"combustion": 0,
	"total": 0
}

# for card game implementation
var card_selected: bool = false
var selected_card: Control 
var droppable_occupied: bool = false
var droppable2_occupied: bool = false
var card_played: Control
var card1
var card2

# set when interacting with the NPC
var reaction_type: String = "synthesis"


# change to play card game when talking to NPC
func switch_scene():
	TransitionLayer.change_scene("res://cards/game_board.tscn")
#	get_tree().change_scene_to_file("res://cards/game_board.tscn")
