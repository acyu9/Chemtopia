extends CanvasLayer


func change_scene(target: String) -> void:
	# Play animation, wait for animation to finish, then change the scene
	$AnimationPlayer.play("fade_to_black")
	await $AnimationPlayer.animation_finished
	if target != "":
		get_tree().change_scene_to_file(target)
	$AnimationPlayer.play_backwards("fade_to_black")
