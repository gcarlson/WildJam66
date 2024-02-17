extends CharacterBody2D

@onready var navAgent = $NavigationAgent2D
@onready var sprite = $AnimatedSprite2D
@onready var stun_sprite = $AnimatedSprite2D2

const SPEED = 60
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var player
var aggroed = false
var stunned = false

var facing_right = true

func _ready():
	player = get_tree().get_first_node_in_group("Player")

func aggro():
	if not stunned:
		aggroed = true
		sprite.play("pursue")

func stun():
	print("stunning bat")
	stunned = true
	stun_sprite.visible = true
	sprite.pause()
	await get_tree().create_timer(2.5).timeout
	stunned = false
	sprite.play()
	stun_sprite.visible = false

func _physics_process(delta):
	if not stunned and aggroed and not player.safe:
		navAgent.target_position = player.global_position + Vector2(0, 0.0 if player.armored else 24.5)
		velocity = (navAgent.get_next_path_position() - global_position).normalized() * SPEED
		sprite.flip_h = (velocity.x > 0)
		sprite.position = Vector2(-8 if facing_right else 8, -17)
		move_and_slide()

func _on_area_2d_body_entered(body):
	if body.is_in_group("Player"):
		print("ddd hit player")
		body.game_over()
