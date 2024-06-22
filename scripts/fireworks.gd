extends AnimatedSprite2D

var allow_move = false
var direction = [0.002, 0, -0.002][randi() % 3]
var color = ['Blue', 'Orange'][randi() % 2]

func _ready():
	play('Flying' + color)
	await get_tree().create_timer(randf_range(0.65, 1)).timeout
	$PointLight2D.queue_free()
	set_process(false)
	play('Explosion' + color)
	await animation_finished
	queue_free()
	
func _process(delta):
	global_position.y -= 3
	rotation += direction
