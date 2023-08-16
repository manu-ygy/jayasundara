extends TileMap


# Called when the node enters the scene tree for the first time.
func _ready():
	spawn_wind()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func spawn_wind():
	var tween = get_tree().create_tween()
	tween.tween_property(get_material(), 'shader_parameter/heightOffset', 0.5, 5)
	tween.tween_property(get_material(), 'shader_parameter/heightOffset', -0.5, 5)

func _on_wind_timer_timeout():
	spawn_wind()
