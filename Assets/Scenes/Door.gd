extends StaticBody2D


@onready var sprite = $AnimatedSprite2D
@onready var occluder = $LightOccluder2D
@onready var collider = $CollisionShape2D

var closed = true
var open_time = 0.0

func open():
	if closed:
		closed = false
		open_time = 1.0
	
func _physics_process(delta):
	if open_time > 0:
		open_time -= delta
		position.y -= delta * 48
