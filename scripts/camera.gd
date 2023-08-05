extends Camera2D

@onready var shake_timer = $ShakeTimer

var shake_amount = 1

func _ready():
	set_process(false)

func _process(delta):
	set_offset(Vector2(randf_range(-1.0, 1.0) * shake_amount, randf_range(-1.0, 1.0) * shake_amount))

func camera_shake(enabled: bool):
	set_process(enabled)
	
func shake_for(duration):
	shake_timer.wait_time = duration
	shake_timer.start()

	set_process(true)

func _on_shake_timer_timeout():
	set_process(false)
