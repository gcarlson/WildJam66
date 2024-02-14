extends StaticBody2D


@onready var sprite = $AnimatedSprite2D
@onready var occluder = $LightOccluder2D
@onready var collider = $CollisionShape2D

func open():
	sprite.play("open")
	occluder.visible = false
	collider.set_deferred("disabled", true)
	
