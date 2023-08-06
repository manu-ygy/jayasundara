extends Area2D

@onready var player = $/root/World/TileMap/Player
@onready var animation = $Animation
@onready var damage_timer = $DamageTimer

var speed = 75
var direction
var prisoned

func _ready():
	set_physics_process(false)

func init(dir):
	direction = dir
	
	animation.play('enterance')
	await animation.animation_finished
	animation.play('loop')
	
	set_physics_process(true)

func _physics_process(delta):
	position += direction * speed * delta

func _on_body_entered(body):
	if (body != player):
		var explode_waittime
		if (body.is_in_group('enemy')):
			prisoned = body
			explode_waittime = 3
			damage_timer.start()
			
			await get_tree().create_timer(0.3).timeout
			
		set_physics_process(false)
		
		if (explode_waittime):
			await get_tree().create_timer(explode_waittime).timeout
		
		animation.play('end')
		await animation.animation_finished
		queue_free()

#		var tween = get_tree().create_tween()
#		tween.tween_property(animation, 'scale', Vector2(0, 0), 0.2)
#
#		await get_tree().create_timer(0.5).timeout

func _on_damage_timer_timeout():
	prisoned.attacked(2)

func _on_area_entered(area):
	if (area.get_parent().is_in_group('destroyable_particle')):
		area.queue_free()
