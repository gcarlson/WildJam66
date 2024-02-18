extends Area2D

@onready var tile = $"../TileMap2"

var active = true

func _on_body_entered(body):
	if active and body.is_in_group("Player") and tile:
		tile.queue_free()
		active = false
