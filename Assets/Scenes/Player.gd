extends CharacterBody2D
@onready var step_sound = $AudioStreamPlayer2D
@onready var big_sprite = $BigAnimatedSprite
@onready var smash_sprite = $SlamSprite
@onready var small_sprite = $SmallAnimatedSprite
@onready var big_collider = $BigCollider
@onready var small_collider = $SmallCollider
@onready var big_lights = $BigLights
@onready var small_lights = $SmallLights
@onready var water_collider = $WaterCollider
@onready var death_splash = $CanvasLayer
@onready var level_splash = $CanvasLayer2
@onready var pause_screen = $PauseScreen
@onready var armor_detector = $ArmorDetector
@onready var level_text = $CanvasLayer2/RichTextLabel
@onready var stun_hitbox = $SlamHitbox
@onready var music = $MusicHandler
@export var level : int

@export var can_swap = true

var scenes = ["res://Assets/Scenes/level_2.tscn", "res://Assets/Scenes/level_1.tscn", "res://Assets/Scenes/level_3.tscn", "res://Assets/Scenes/home_page.tscn"]

const SPEED = 250.0
const JUMP_VELOCITY = -325.0
const SQUAT_DUR = 0.1
const DASH_SPEED = 400
const DASH_DURATION = 0.2

var dashing = false
var safe = false
var armored = false
var active_sprite = big_sprite
var tilemap

var last_ground = Vector2(0, 0)
var anim_locked = false
var frozen = false
var can_dash = true

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	tilemap = get_tree().get_first_node_in_group("Tilemap")
	music.autoplay = true;
	music.play()

func _physics_process(delta):
	if dashing:
		velocity = Vector2(-DASH_SPEED if big_sprite.flip_h else DASH_SPEED, 0)
		move_and_slide()
		return
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		can_dash = true
		if not safe:
			last_ground = global_position

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		delayed_jump()
		
	if Input.is_action_just_pressed("ability_1") and !anim_locked:
		if armored:
			#print("ddd tile: ", tilemap.local_to_map(global_position + Vector2(0, 36)))
			big_sprite.play("Smash")
			smash_sprite.play("slam")
			delayed_smash()
			anim_locked = true
		elif can_dash:
			dashing = true
			can_dash = false
			small_sprite.play("dash")
			stop_dash()
			return
		
	if Input.is_action_just_pressed("switch_form") and can_swap and not anim_locked and (armored or not armor_detector.overlaps_body(tilemap)):
		swap_forms()
		
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction and not anim_locked:
		if armored:
			velocity.x = direction * SPEED * .7
		else:
			velocity.x = direction * SPEED
		big_sprite.flip_h = (direction < 0)
		small_sprite.flip_h = (direction < 0)
		if not anim_locked and not armored:
			small_sprite.play("walk")
		if not anim_locked and armored:
			big_sprite.play("Walk")
			for x in get_tree().get_nodes_in_group("Bats"):
				if (x.global_position - global_position).length() < 128:
					x.aggro()
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		#velocity.x = velocity.x / 2
		if not anim_locked:
			big_sprite.play("Idle")
			small_sprite.play("Idle")

	if frozen:
		velocity.x = 0
	move_and_slide()
	
func delayed_jump():
	velocity.y = JUMP_VELOCITY if not armored else 0.7 * JUMP_VELOCITY
	await get_tree().create_timer(SQUAT_DUR).timeout
	print("ddd squat over ", Input.is_action_pressed("ui_accept"), " ", velocity.y)
	if not Input.is_action_pressed("ui_accept") and not armored:
		velocity.y = JUMP_VELOCITY * 0.3

func swap_forms():
	can_swap = true
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

func stop_dash():
	await get_tree().create_timer(DASH_DURATION).timeout
	dashing = false

func delayed_smash():
	await get_tree().create_timer(0.65).timeout
	for x in stun_hitbox.get_overlapping_bodies():
		if x.is_in_group("Moles") or x.is_in_group("Bats"):
			x.stun()
	for x in range(-16, 17, 16):
		var tile = tilemap.local_to_map(global_position + Vector2(x, 36))
		print("ddd tile: ", tilemap.get_cell_atlas_coords(0, tile))
		if (tilemap.get_cell_atlas_coords(0, tile) == Vector2i(14, 0)):
			tilemap.erase_cell(0, tile)
		
	print("After timout")

func _on_big_animated_sprite_animation_finished():
	anim_locked = false

func game_over():
	death_splash.visible = true
	await get_tree().create_timer(1).timeout
	get_tree().call_deferred("reload_current_scene")
	
func complete_level():
	frozen = true
	await get_tree().create_timer(4).timeout
	if level == 3:
		level_text.text = "[center]Thanks For Playing!"
	level_splash.visible = true
	await get_tree().create_timer(4).timeout
	get_tree().change_scene_to_file(scenes[level])

func _on_water_collider_body_entered(body):
	game_over()


func _on_big_animated_sprite_frame_changed():
	if big_sprite.animation == "Walk" && armored: # && is_on_floor():
		if big_sprite.frame == 3 || big_sprite.frame == 7:
			step_sound.play()


func _on_big_animated_sprite_animation_changed():
	
	if big_sprite && big_sprite.animation == "Walk" && armored: # && $AudioStreamPlayer2D2.playing == false:
		$AudioStreamPlayer2D2.play()


func _on_music_handler_finished():
	music.play() # Replace with function body.
