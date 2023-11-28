extends Node2D

#func _ready():
#	print(Globals.location)
#	set_music()
	


func set_music():
	if Globals.location == "house" and not $ChildhoodFriend.playing:
		$GeneralMusic.playing = false
		$ChildhoodFriend.playing = true
	elif Globals.location == "outside" and not $GeneralMusic.playing:
		$ChildhoodFriend.playing = false
		$GeneralMusic.playing = true
	elif Globals.location == "card":
		$GeneralMusic.playing = false
