extends CanvasLayer


@onready var pause = $"../PauseScreen"

var index = 0

var move_cooldown = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if not visible:
		return
	if Input.is_action_just_pressed("ui_accept") or Input.is_action_just_pressed("ui_cancel"):
		await get_tree().create_timer(0.1).timeout
		pause.visible = true
		visible = false
		
