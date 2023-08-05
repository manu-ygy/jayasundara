extends CharacterBody2D

@onready var world = $/root/World

@onready var animation = $AnimatedSprite2D
@onready var dash_timer = $DashTimer
@onready var attack_timer = $AttackTimer
@onready var bump_detection = $Area2D/CollisionShape2D
@onready var muzzle = $Muzzle
@onready var indicator = $Indicator

@onready var camera = $Camera2D

var bullet_instance = load('res://bullet.tscn')

const movement_speed = 125
const dash_speed = 450

var is_dashing = false
var is_stunned = false
var is_attacking = false

var last_ghost_pos = Vector2()

func _physics_process(delta):
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var speed = dash_speed if is_dashing else movement_speed
	velocity = direction * speed if !is_stunned else Vector2.ZERO 
	
	if (!is_attacking):
		if (velocity == Vector2.ZERO):
			animation.play('idle')
		else:
			animation.flip_h = velocity.x <= 0
			muzzle.rotation = velocity.angle()
			indicator.rotation = velocity.angle()
			indicator.position.x = round(direction.x) * 6
			indicator.position.y = 8 if (direction.y > 0) else 11
			
			if (is_dashing):
				animation.play('dash')
			else:
				animation.play('walk')
	else:
		animation.play('attack')
	
	move_and_slide()
	
func _input(event):
	if (Input.is_action_just_pressed('dash') and !is_dashing and velocity != Vector2.ZERO):
		is_dashing = true
		bump_detection.disabled = false
		dash_timer.start()
		
		for x in range(8):
			await get_tree().create_timer(0.03).timeout
			
			if (last_ghost_pos != global_position):
				var ghost = AnimatedSprite2D.new()
				ghost.sprite_frames = animation.sprite_frames
				ghost.global_position = global_position
				ghost.frame = animation.frame
				ghost.animation = animation.animation
				ghost.flip_h = animation.flip_h
				ghost.z_index = 0
				
				var tween = get_tree().create_tween()
				tween.tween_property(ghost, 'modulate', Color(1, 1, 1, 0), 0.2)
				tween.tween_callback(ghost.queue_free)
				
				last_ghost_pos = global_position
				
				world.add_child(ghost)
				
	if (Input.is_action_just_pressed('shoot')):
		is_attacking = true
		attack_timer.start()
		
		await get_tree().create_timer(0.2).timeout
		
		var bullet = bullet_instance.instantiate()
		bullet.transform = muzzle.transform
		bullet.global_position = global_position
		world.add_child(bullet)

func _on_dash_timer_timeout():
	is_dashing = false
	bump_detection.disabled = true

func _on_area_2d_body_entered(body):
	if (body is TileMap):
		var tween = get_tree().create_tween()
		camera.shake_for(0.5)
		is_stunned = true
		
		tween.tween_property(animation, 'self_modulate', Color(0.8, 0, 0, 1), 0.2)
		tween.tween_property(animation, 'self_modulate', Color(1, 1, 1, 1), 0.2)
		
		await get_tree().create_timer(0.5).timeout
		is_stunned = false

func _on_attack_timer_timeout():
	is_attacking = false
