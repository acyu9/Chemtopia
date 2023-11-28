extends CanvasLayer

@onready var original_color = $TextureButton.modulate


func _on_texture_button_pressed():
	$TextureButton.modulate = original_color
	
	# only show the first page if first page & second page are both not open
	if not $Chemtopia.visible and not $Chemtopia2.visible:
		$Chemtopia.visible = true
		$NextPageButton.visible = true
		$Label.text = "X"
	# close all pages
	else:
		$Chemtopia.visible = false
		$Chemtopia2.visible = false
		$NextPageButton.visible = false
		$Label.text = "C"
	

func _on_texture_button_button_down():
	$TextureButton.modulate = original_color.darkened(0.2)


func _on_texture_button_button_up():
	$TextureButton.modulate = original_color


# "flip" to next page
func _on_next_page_button_pressed():
	$Chemtopia.visible = false
	$Chemtopia2.visible = true
	$PreviousPageButton.visible = true
	$NextPageButton.visible = false


# 'flip' to previous page
func _on_previous_page_button_pressed():
	$Chemtopia.visible = true
	$Chemtopia2.visible = false
	$PreviousPageButton.visible = false
	$NextPageButton.visible = true
