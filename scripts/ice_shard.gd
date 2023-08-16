extends Area2D

@onready var player = $/root/Loader/World/TileMap/Player
@onready var collision = $Collision
@onready var animation = $Animation
@onready var freeze_radius = $FreezeRadius

var speed = 250
var is_destroyed = false
var target_body
var is_body_inside = false

var direction
var sender

func _ready():
	add_to_group('destroyable_particle')
	
	set_physics_process(false)

func init(dir, send):
	direction = dir
	sender = send
	
	animation.rotation = direction.angle()
	collision.rotation = direction.angle()
	
	animation.play('enterance')
	await animation.animation_finished
	animation.play('loop')
	
	set_physics_process(true)

func _physics_process(delta):
	position += direction * speed * delta
	
func _on_body_entered(body):
	if (body != sender and !is_destroyed):
		destroy(body)

func destroy(body):
	collision.set_deferred('disabled', true) 
	
	if (!is_destroyed):
		is_destroyed = true
		is_body_inside = true
		target_body = body
		
		set_physics_process(false)
		
		animation.play('end')
		await animation.animation_finished
		
		if (is_instance_valid(body) and (body.is_in_group('enemy') or body == player)):
			animation.rotation = 0
			global_position = body.global_position - Vector2(4, 0)
			animation.play('crystal_enterance')
			await animation.animation_finished
			
			freeze_radius.set_deferred('disabled', false)
			connect('body_exited', _on_body_exited)
			
			if (is_body_inside):
				body.get_node('Animation').modulate = Color.BLUE
				body.is_stunned = true
				
			animation.play('crystal_active')
			await get_tree().create_timer(2).timeout
			
			animation.play('crystal_end')
			body.get_node('Animation').modulate = Color(1, 1, 1, 1)
			body.is_stunned = false
			await animation.animation_finished
			
		queue_free()
	else:
		is_body_inside = true

func _on_body_exited(body):
	if (body == target_body):
		is_body_inside = false
	
func _on_area_entered(area):
	if (area.is_in_group('destroyable_particle') and area.sender != sender):
		destroy(area)
		area.destroy(self)
