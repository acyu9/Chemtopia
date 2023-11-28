extends CanvasLayer

@onready var original_color = Color(1, 1, 1, 1)

func _ready():
	set_health()


func _process(_delta):
	set_health()


func set_health():
	if Globals.energy <= 2:
		$HBoxContainer/Heart3.modulate = original_color.darkened(0.4)
	if Globals.energy <= 1:
		$HBoxContainer/Heart2.modulate = original_color.darkened(0.4)
	if Globals.energy <= 0:
		$HBoxContainer/Heart1.modulate = original_color.darkened(0.4)
	
	# reset health hearts
	if Globals.energy == 3:
		$HBoxContainer/Heart3.modulate = original_color
		$HBoxContainer/Heart2.modulate = original_color
		$HBoxContainer/Heart1.modulate = original_color
