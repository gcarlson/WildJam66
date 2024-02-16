extends CanvasLayer


@onready var buttons = [$RichTextLabel2, $RichTextLabel3, $RichTextLabel4, $RichTextLabel5]

var index = 0

var move_cooldown = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):	
	if Input.is_action_just_pressed("ui_cancel"):
		print("ddd unpause")
		visible = not visible
		get_tree().paused = visible
		print("ddd unpause done")
		
	if get_tree().paused:
		if Input.is_action_just_pressed("ui_accept"):
			if index == 0:
				visible = not visible
				get_tree().paused = visible
			elif index == 1:
				visible = not visible
				get_tree().paused = visible
				get_tree().call_deferred("reload_current_scene")
		move_cooldown -= delta
		var direction = Input.get_axis("ui_up", "ui_down")
		if direction and move_cooldown <= 0:
			var s = buttons[index].text
			print("substr ", s.substr(1, len(s) - 2))
			buttons[index].text = s.substr(1, len(s) - 2)
			index = (index + (1 if direction > 0 else -1) + 4) % 4
			buttons[index].text = ">" + buttons[index].text + "<"
			move_cooldown = 0.5
		
