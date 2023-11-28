extends CanvasLayer

@onready var original_color = $TextureButton.modulate


func _on_texture_button_pressed():
	$TextureButton.modulate = original_color
	
	if not $GameRules.visible:
		$GameRules.visible = true
		$Label.text = "X"
	else:
		$GameRules.visible = false
		$Label.text = "R"
	

func _on_texture_button_button_down():
	$TextureButton.modulate = original_color.darkened(0.2)


func _on_texture_button_button_up():
	$TextureButton.modulate = original_color
