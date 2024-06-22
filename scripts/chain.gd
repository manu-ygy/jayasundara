extends Sprite2D

signal chain_ended
var asked_for_spawn = false

func _process(delta):
	global_position.y += 1

	if (global_position.y >= -64 and !asked_for_spawn):
		emit_signal('chain_ended')
		asked_for_spawn = true
	
	if (global_position.y > 154):
		queue_free()
