extends CanvasLayer

@onready var animation = $Animation

# Called when the node enters the scene tree for the first time.
func _ready():
	animation.play('animation')
	animation.seek(10, true)
	animation.speed_scale = 0.125

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
