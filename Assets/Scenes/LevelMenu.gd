extends CanvasLayer


@onready var buttons = [$RichTextLabel2, $RichTextLabel3, $RichTextLabel4, $RichTextLabel5]
@onready var main_menu = $"../MainMenu"
var scenes = ["res://Assets/Scenes/level_2.tscn", "res://Assets/Scenes/level_1.tscn", "res://Assets/Scenes/level_3.tscn"]

var index = 0

var move_cooldown = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if not visible:
		return
	if Input.is_action_just_pressed("ui_accept"):
		if index == 3:
			await get_tree().create_timer(0.1).timeout
			main_menu.visible = true
			visible = false
		else:
			get_tree().change_scene_to_file(scenes[index])
	else:
		move_cooldown -= delta
		var direction = Input.get_axis("ui_up", "ui_down")
		if direction and move_cooldown <= 0:
			var s = buttons[index].text
			print(len(s))
			print("substr ", s.substr(9, len(s) - 10))
			buttons[index].text = "[center]" + s.substr(9, len(s) - 10)
			index = (index + (1 if direction > 0 else -1) + 4) % 4
			s = buttons[index].text
			buttons[index].text = "[center]>" + s.substr(8, len(s) - 1) + "<"
			move_cooldown = 0.2
