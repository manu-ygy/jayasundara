extends CanvasLayer

@onready var modulate = $/root/Loader/World/Modulate
@onready var animation = $Animation

# Called when the node enters the scene tree for the first time.
func _ready():
	# modulate.show()
	animation.play('animation')
	animation.seek(10, true)
	animation.speed_scale = 0.0125
	animation.pause()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
