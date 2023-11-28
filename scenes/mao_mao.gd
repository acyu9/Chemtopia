extends StaticBody2D

@onready var _animated_sprite = $AnimatedSprite2D

# always play animation & animation can be set via global variable
func _process(_delta):
	_animated_sprite.play(Globals.maomao_animation)
