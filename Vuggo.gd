extends CharacterBody2D

@onready var ray = $RayCast2D
@onready var sprite = $AnimatedSprite2D
@onready var nosecol = $Area2D
const SPEED = 300.0
var facing_left = true
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")



func is_lit():
	for x in get_tree().get_nodes_in_group("Lights"):
		if x.visible:
			ray.target_position = x.global_position - global_position
			ray.force_raycast_update()
			if (not ray.is_colliding() and ray.target_position.length() < 128):
				return true
	return false
	
func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	velocity.x = -30 if facing_left else 30
	
#if is_lit():
	
	move_and_slide()
	
	


func _on_area_2d_body_entered(body):
	facing_left = not facing_left
	print ("slapa")
	sprite.flip_h = not facing_left
	nosecol.position.x = -15 if facing_left else 15
	
	
