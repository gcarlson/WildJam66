extends CharacterBody2D

@onready var rays = $Node2D
@onready var forwardray = $Node2D/RayCast2D
@onready var rightray = $Node2D/RayCast2D2
@onready var leftray = $Node2D/RayCast2D3

const SPEED = 60
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var player
var aggroed = false

var facing_right = true
var tunnel_cooldown = 5
var tunnel_dur = -1
var tunnel_target


func _ready():
	print("ddd init")
	player = get_tree().get_first_node_in_group("Player")

func _physics_process(delta):
	if aggroed:
		var target = player.global_position + Vector2(0, 0 if player.armored else 24.5)
		rays.look_at(target)
		if (target - global_position).length() < 60 or not forwardray.is_colliding():
			velocity = (target - global_position).normalized() * SPEED
		elif not rightray.is_colliding():
			velocity = (target - global_position).normalized().rotated(PI / 3) * SPEED
		elif not leftray.is_colliding():
			velocity = (target - global_position).normalized().rotated(-PI / 3) * SPEED
		else:
			velocity = (target - global_position).normalized() * SPEED
		move_and_slide()

func _on_area_2d_body_entered(body):
	if body.is_in_group("Player"):
		print("ddd hit player")
		get_tree().reload_current_scene()
