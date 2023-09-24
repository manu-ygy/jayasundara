extends Area2D

var speed = 500
var sender
var direction

@onready var animation = $Animation
@onready var light = $Light

var is_destroyed = false

func _ready():
	add_to_group('destroyable_particle')
	
	set_physics_process(false)

func init(dir, send):
	direction = dir
	sender = send
	
	set_physics_process(true)
	
	animation.play('default')
	await animation.animation_finished
	
	await get_tree().create_timer(0.5).timeout
	
	var tween = get_tree().create_tween()
	tween.tween_property(light, 'scale', Vector2(3, 3), 0.5)

func destroy(body):
	is_destroyed = true
	
	set_physics_process(false)

	var tween = get_tree().create_tween()
		
	if ((body is CharacterBody2D or body.is_in_group('enemy')) and body != sender):
		body.attacked(25)
		
	await get_tree().create_timer(0.5).timeout
	
	queue_free()

func _on_body_entered(body):
	if (body != sender):
		destroy(body)

func _on_area_entered(area):
	if (area.is_in_group('destroyable_particle') and area.sender != sender and !is_destroyed):
		destroy(area)
		area.destroy(self)
