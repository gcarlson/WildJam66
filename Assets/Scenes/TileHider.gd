extends Area2D

@onready var tile = $"../TileMap2"

func _on_body_entered(body):
	if body.is_in_group("Player") and tile:
		tile.queue_free()
