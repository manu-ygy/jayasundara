extends Node2D

@onready var player = $/root/Loader/World/TileMap/Player
@onready var collision = $FreezeCollision/Collision
@onready var animation = $Animation
@onready var freeze_collision = $ShardCollision/Collision

var speed = 300
var is_destroyed = false
var target_body
var is_body_inside = false

var direction
var sender

func _ready():
	add_to_group('destroyable_particle')
	
	set_physics_process(false)

func init(dir, send):
	set_physics_process(true)
	
	direction = dir
	sender = send
	
	animation.rotation = direction.angle()
	collision.rotation = direction.angle()
	
	animation.play('enterance')
	await animation.animation_finished
	animation.play('loop')

func _physics_process(delta):
	position += direction * speed * delta
	
func _on_freeze_collision_body_entered(body):
	if (body != sender and !is_destroyed):
		destroy(body)

func destroy(body):
	collision.set_deferred('disabled', true) 
	
	if (!is_destroyed):
		is_destroyed = true
		
		set_physics_process(false)
		
		if (is_instance_valid(body) and (body.is_in_group('enemy') or body == player)):
			body.movement_speed -= 35
			
			animation.play('end')
			await animation.animation_finished
			
			freeze_collision.set_deferred('disabled', false)
			target_body = body
			
			animation.rotation = 0
			global_position = body.global_position - Vector2(4, 0)
			animation.play('crystal_enterance')
			await animation.animation_finished
			
			body.movement_speed += 35
			
			if (is_body_inside):
				body.get_node('Animation').modulate = Color.BLUE
				body.is_stunned = true
				
			animation.play('crystal_active')
			await get_tree().create_timer(2).timeout
			
			animation.play('crystal_end')
			body.get_node('Animation').modulate = Color(1, 1, 1, 1)
			body.is_stunned = false
			await animation.animation_finished
			
		else:
			animation.play('end')
			await animation.animation_finished
			
		queue_free()
	
func _on_freeze_collision_area_entered(area):
	if (area.is_in_group('destroyable_particle') and area.sender != sender):
		destroy(area)
		area.destroy(self)

func _on_shard_collision_body_entered(body):
	if (body == target_body):
		is_body_inside = true

func _on_shard_collision_body_exited(body):
	if (body == target_body):
		is_body_inside = false
