extends CharacterBody2D

@onready var big_sprite = $BigAnimatedSprite
@onready var small_sprite = $SmallAnimatedSprite
@onready var big_collider = $BigCollider
@onready var small_collider = $SmallCollider
@onready var big_lights = $BigLights
@onready var small_lights = $SmallLights

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var armored = true
var active_sprite = big_sprite
var tilemap

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	tilemap = get_tree().get_first_node_in_group("Tilemap")

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if not armored and Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	if not armored and Input.is_action_just_pressed("ability_1"):
		velocity.x = 100
		
	if armored and Input.is_action_just_pressed("ability_1"):
		#print("ddd tile: ", tilemap.local_to_map(global_position + Vector2(0, 36)))
		for x in range(-16, 17, 16):
			tilemap.erase_cell(0, tilemap.local_to_map(global_position + Vector2(x, 36)))
		
	if Input.is_action_just_pressed("switch_form"):
		armored = not armored
		
		big_sprite.visible = armored
		big_collider.disabled = not armored
		small_sprite.visible = not armored
		small_collider.disabled = armored
		
		small_lights.visible = not armored
		big_lights.visible = armored
		
		if armored:
			active_sprite = big_sprite
		else:
			active_sprite = small_sprite
		
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
		big_sprite.flip_h = (direction < 0)
		small_sprite.flip_h = (direction < 0)
		big_sprite.play("Walk")
	else:
		print("ddd ", velocity.x)
		#velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.x = velocity.x / 2
		print("ddd adjusted ", velocity.x)
		big_sprite.play("Idle")

	move_and_slide()
