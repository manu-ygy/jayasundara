extends Camera2D

@onready var player = get_node_or_null('/root/Loader/World/TileMap/Player')

@onready var shake_timer = $ShakeTimer
@onready var following = player

var shake_amount = 1

func _ready():
	set_process(false)
	
	await get_tree().process_frame
	
	position_smoothing_enabled = true
	rotation_smoothing_enabled = true

func _physics_process(_delta):
	if (following):
		global_position = following.global_position

func _process(_delta):
	set_offset(Vector2(randf_range(-1.0, 1.0) * shake_amount, randf_range(-1.0, 1.0) * shake_amount))

func camera_shake(shaking: bool):
	set_process(shaking)
	
func shake_for(duration):
	shake_timer.wait_time = duration
	shake_timer.start()

	set_process(true)

func _on_shake_timer_timeout():
	set_process(false)
