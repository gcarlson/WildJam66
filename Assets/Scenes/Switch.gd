extends Area2D

@onready var sprite = $AnimatedSprite2D

@export var door : Node

var active = true

func _on_body_entered(body):
	if active and body.is_in_group("Player"):
		sprite.play("down")
		door.open()
		active = false
