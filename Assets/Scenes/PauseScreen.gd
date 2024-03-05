extends CanvasLayer


@onready var buttons = [$RichTextLabel2, $RichTextLabel3, $RichTextLabel4, $RichTextLabel5, $RichTextLabel6]
@onready var controls = $"../ControlsScreen"
@onready var difficulty = $"../LevelMenu"
var index = 0

var move_cooldown = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):	
	if Input.is_action_just_pressed("ui_cancel") and not controls.visible and not difficulty.visible:
		print("ddd unpause")
		visible = not visible
		get_tree().paused = visible
		print("ddd unpause done")
		
	if get_tree().paused and visible:
		if Input.is_action_just_pressed("ui_accept"):
			if index == 0:
				visible = not visible
				get_tree().paused = visible
			elif index == 1:
				visible = not visible
				get_tree().paused = visible
				get_tree().call_deferred("reload_current_scene")
			elif index == 2:
				await get_tree().create_timer(0.1).timeout
				controls.visible = true
				visible = false
			elif index == 3:
				await get_tree().create_timer(0.1).timeout
				difficulty.visible = true
				visible = false
			elif index == 4:
				visible = not visible
				get_tree().paused = visible
				get_tree().change_scene_to_file("res://Assets/Scenes/home_page.tscn")
		move_cooldown -= delta
		var direction = Input.get_axis("ui_up", "ui_down")
		if direction and move_cooldown <= 0:
			var s = buttons[index].text
			print("substr ", s.substr(1, len(s) - 2))
			buttons[index].text = "[center]" + s.substr(9, len(s) - 10)
			#buttons[index].text = s.substr(1, len(s) - 2)
			index = (index + (1 if direction > 0 else -1) + 5) % 5
			s = buttons[index].text
			buttons[index].text = "[center]>" + s.substr(8, len(s) - 1) + "<"
			move_cooldown = 0.2
		
