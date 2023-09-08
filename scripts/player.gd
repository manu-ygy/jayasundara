extends CharacterBody2D

@onready var ui = $/root/Loader/World
@onready var world = $/root/Loader/World/TileMap

@onready var dash_timer = $DashTimer
@onready var bump_detection = $Area2D/CollisionShape2D
@onready var state_machine = $AnimationTree.get('parameters/playback')
@onready var animation = $AnimationTree
@onready var sprite = $Sprite

var movement_speed = 125
var dash_speed = 450

var last_ghost_pos = Vector2()

var is_dashing = false
var is_stunned = false

var dust_instance = load('res://dash.tres')

func _physics_process(delta):
	var direction = Input.get_vector('left', 'right', 'up', 'down')
	var speed = dash_speed if is_dashing else movement_speed
	velocity = direction * speed if !is_stunned else Vector2.ZERO
			
	if (velocity != Vector2.ZERO):
		animation.set('parameters/walk/blend_position', direction)
		animation.set('parameters/dash/blend_position', direction)
		animation.set('parameters/idle/blend_position', direction)
	
		if (is_dashing):
			state_machine.travel('dash')
		else:
			state_machine.travel('walk')
	else:
		state_machine.travel('idle')
	
	move_and_slide()

func _input(event):
	if (Input.is_action_just_pressed('base_skill') and !is_dashing and velocity != Vector2.ZERO):
		is_dashing = true
		bump_detection.disabled = false
		dash_timer.start()
		
		var dust = AnimatedSprite2D.new()
		dust.global_position = global_position
		dust.sprite_frames = dust_instance
		dust.play('default')
		dust.connect('animation_finished', dust.queue_free)
		
		world.add_child(dust)
		
		for x in range(6):
			await get_tree().create_timer(0.03).timeout
			
			if (last_ghost_pos != global_position):
				var ghost = Sprite2D.new()
				ghost.texture = sprite.texture
				ghost.global_position = global_position
				ghost.hframes = sprite.hframes
				ghost.vframes = sprite.vframes
				ghost.frame = sprite.frame
				ghost.flip_h = sprite.flip_h
				ghost.z_index = 1
				ghost.z_as_relative = false
				
				var tween = get_tree().create_tween()
				tween.tween_property(ghost, 'modulate', Color(1, 1, 1, 0), 0.2)
				tween.tween_callback(ghost.queue_free)
				
				last_ghost_pos = global_position
				
				world.add_child(ghost)

func _on_dash_timer_timeout():
	is_dashing = false
	bump_detection.disabled = true
