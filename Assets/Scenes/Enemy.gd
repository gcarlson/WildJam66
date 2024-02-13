extends CharacterBody2D

@onready var ray = $RayCast2D
@onready var reaction = $RichTextLabel

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var player

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
	if is_lit():
		reaction.text = "[center]![/center]"
		#print("ddd light")
	else:
		reaction.text = ""
		#print("ddd dark")
