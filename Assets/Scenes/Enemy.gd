extends CharacterBody2D

@onready var ray = $RayCast2D
@onready var reaction = $RichTextLabel

const SPEED = 300.0
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
		
	if aggroed:
		tunnel_cooldown -= delta
		if tunnel_cooldown < 0:
			tunnel_cooldown = 5
			tunnel_dur = 0.5
			tunnel_target = player.last_ground + Vector2(0, 16)
		if tunnel_dur > 0:
			velocity.x = 0
			tunnel_dur -= delta
			if tunnel_dur <= 0:
				position = tunnel_target
		else:
			if abs(player.global_position.x - global_position.x) > 8:
				facing_right = (player.global_position.x > global_position.x)
			velocity.x = 15 if facing_right else -15

	if is_lit():
		reaction.text = "[center]![/center]"
		aggroed = true
		#print("ddd light")
	else:
		reaction.text = ""
		#print("ddd dark")

	move_and_slide()
