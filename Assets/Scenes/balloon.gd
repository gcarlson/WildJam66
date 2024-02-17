extends Area2D

@onready var sprite = $AnimatedSprite2D

var done = false
var sprites = ["0suns", "1sun", "2suns", "3suns"]

# Called when the node enters the scene tree for the first time.
func _ready():
	sprite.play(sprites[get_tree().get_first_node_in_group("Player").level - 1])

func complete(level):
	done = true
	sprite.play(sprites[level])
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if done:
		position.y -= delta * 64
