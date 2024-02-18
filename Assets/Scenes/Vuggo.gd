extends CharacterBody2D

@onready var ray = $RayCast2D
@onready var sprite = $AnimatedSprite2D
@onready var nosecol = $Area2D
const SPEED = 300.0
var facing_left = true
var light_time = 0.0
var player_colliding = null

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
		
	if is_lit():
		velocity.x = 0
		light_time += delta
		if light_time > 1.5 and light_time - delta <= 1.5:
			$AnimatedSprite2D.play("Fling")
			if player_colliding and player_colliding.is_on_floor():
				player_colliding.velocity.y = -600
		elif (sprite.animation != "Fling"):
			sprite.play("idle")	
			
	else:
		velocity.x = -30 if facing_left else 30
		sprite.play("default")
		light_time = 0
	
	move_and_slide()

func _on_area_2d_body_entered(body):
	facing_left = not facing_left
	sprite.flip_h = facing_left
	nosecol.position.x = -15 if facing_left else 15

func _on_area_2d_2_body_entered(body):
	print("top collided")
	if (body.is_in_group("Player")):
		player_colliding = body

func _on_area_2d_2_body_exited(body):
	if (body.is_in_group("Player")):
		player_colliding = null


func _on_animated_sprite_2d_animation_finished():
	if sprite.animation == "Fling":
		$AnimatedSprite2D.play("default")
		light_time = 0
