extends CharacterBody2D

@onready var ray = $RayCast2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var player

func _ready():
	print("ddd init")
	player = get_tree().get_first_node_in_group("Player")
	

func _physics_process(delta):
	ray.target_position = player.global_position - global_position + Vector2(0, 25)
	if (not ray.is_colliding() and not player.armored and ray.target_position.length() < 128):
		print("ddd light")
	else:
		print("ddd dark")
