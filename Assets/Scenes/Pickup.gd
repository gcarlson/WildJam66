extends Area2D

var player = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player:
		position = player.global_position + Vector2(0, -22 if player.armored else 0)


func _on_body_entered(body):
	
	if not player && body.is_in_group("Player"):
		print("ddd pickup")
		player = body
		#body.add_child(self)
	
