extends CharacterBody2D

@onready var ray = $RayCast2D
@onready var reaction = $RichTextLabel
@onready var sprite = $AnimatedSprite2D

@onready var collider = $CollisionShape2D
@onready var hitbox = $Area2D/CollisionShape2D

@onready var stun_sprite = $AnimatedSprite2D2

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var player
var aggroed = false
var stunned = false

@export var facing_right = true
var tunnel_cooldown = 5
var tunnel_dur = -1
var tunnel_target
var burrowing = false


func _ready():
	print("ddd init")
	player = get_tree().get_first_node_in_group("Player")
	sprite.flip_h = not facing_right
	
func is_lit():
	for x in get_tree().get_nodes_in_group("Lights"):
		if x.visible:
			ray.target_position = x.global_position - global_position
			ray.force_raycast_update()
			if (not ray.is_colliding() and ray.target_position.length() < 128):
				return true
	return false

func _physics_process(delta):
	if stunned:
		return

	# Add the gravity.
	if not is_on_floor() and not burrowing:
		velocity.y += gravity * delta
		
	if player.safe:
		velocity.x = 0
	elif aggroed:
		tunnel_cooldown -= delta
		if tunnel_cooldown < 0:
			tunnel_cooldown = 5
			burrowing = true
			velocity.x = 0
			tunnel_target = player.last_ground + Vector2(0, 16)
			sprite.play("burrow")
		elif not burrowing:
			if abs(player.global_position.x - global_position.x) > 8:
				facing_right = (player.global_position.x > global_position.x)
				sprite.flip_h = not facing_right
			velocity.x = 15 if facing_right else -15

	if is_lit():
		#reaction.text = "[center]![/center]"
		aggroed = true
		#print("ddd light")

	move_and_slide()

func stun():
	print("stunning mole")
	stunned = true
	stun_sprite.visible = true
	sprite.pause()
	await get_tree().create_timer(2.5).timeout
	stunned = false
	sprite.play()
	stun_sprite.visible = false

func _on_area_2d_body_entered(body):
	if body.is_in_group("Player"):
		print("ddd hit player")
		body.game_over()
		#get_tree().reload_current_scene()


func _on_animated_sprite_2d_animation_finished():
	if sprite.animation == "burrow":
		sprite.play("unburrow")
		position = tunnel_target
		collider.disabled = true
		hitbox.disabled = true
	elif sprite.animation == "unburrow":
		sprite.play("idle")
		burrowing = false
		collider.disabled = false
		hitbox.disabled = false
