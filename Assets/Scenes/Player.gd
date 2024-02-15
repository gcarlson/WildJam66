extends CharacterBody2D

@onready var big_sprite = $BigAnimatedSprite
@onready var small_sprite = $SmallAnimatedSprite
@onready var big_collider = $BigCollider
@onready var small_collider = $SmallCollider
@onready var big_lights = $BigLights
@onready var small_lights = $SmallLights
@onready var water_collider = $WaterCollider
@onready var death_splash = $CanvasLayer

const SPEED = 250.0
const JUMP_VELOCITY = -325.0

var armored = true
var active_sprite = big_sprite
var tilemap

var last_ground = Vector2(0, 0)
var anim_locked = false

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	tilemap = get_tree().get_first_node_in_group("Tilemap")

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		last_ground = global_position

	# Handle jump.
	if not armored and Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	if armored and Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY*.7
		
	if armored and Input.is_action_just_pressed("ability_1") and !anim_locked:
		#print("ddd tile: ", tilemap.local_to_map(global_position + Vector2(0, 36)))
		big_sprite.play("Smash")
		delayed_smash()
		anim_locked = true
		#for x in range(-16, 17, 16):
		#	tilemap.erase_cell(0, tilemap.local_to_map(global_position + Vector2(x, 36)))
		
	if Input.is_action_just_pressed("switch_form"):
		armored = not armored
		water_collider.position.y = 0 if armored else 26
		
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
		if armored:
			velocity.x = direction * SPEED * .7
		else:
			velocity.x = direction * SPEED
		big_sprite.flip_h = (direction < 0)
		small_sprite.flip_h = (direction < 0)
		if not anim_locked and armored:
			big_sprite.play("Walk")
			for x in get_tree().get_nodes_in_group("Bats"):
				if (x.global_position - global_position).length() < 128:
					x.aggroed = true
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		#velocity.x = velocity.x / 2
		if not anim_locked:
			big_sprite.play("Idle")

	move_and_slide()
	

func delayed_smash():
	await get_tree().create_timer(0.65).timeout
	for x in range(-16, 17, 16):
		tilemap.erase_cell(0, tilemap.local_to_map(global_position + Vector2(x, 36)))
		
	print("After timout")

func _on_big_animated_sprite_animation_finished():
	anim_locked = false

func game_over():
	death_splash.visible = true
	await get_tree().create_timer(1).timeout
	get_tree().call_deferred("reload_current_scene")

func _on_water_collider_body_entered(body):
	game_over()
