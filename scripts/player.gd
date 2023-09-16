extends CharacterBody2D

signal arrived_at_path

@onready var ui = $/root/Loader/World
@onready var world = $/root/Loader/World/TileMap

@onready var base_skill_progress = $/root/Loader/World/UI/Stat/BaseSkill

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

var base_skill_cooldown = 2
var is_base_skill_cooldown = false

var dust_instance = load('res://dash.tres')

var current_path = []
var current_point = null
var path_index = 0

func _physics_process(delta):
	if (is_stunned and current_point):
		if (global_position.distance_to(current_path[path_index]) > 2):
			velocity = global_position.direction_to(current_path[path_index]) * movement_speed
		else:
			velocity = Vector2.ZERO
			if (current_path.size() > path_index):
				path_index += 1
			else:
				emit_signal('arrived_at_path')
	else:
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
	if (Input.is_action_just_pressed('base_skill') and !is_dashing and !is_base_skill_cooldown and velocity != Vector2.ZERO):
		is_base_skill_cooldown = true
		base_skill_progress.value = 0
		
		is_dashing = true
		bump_detection.disabled = false
		dash_timer.start()
		
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
				
		var tween = get_tree().create_tween()
		tween.tween_property(base_skill_progress, 'value', 100, base_skill_cooldown)
		tween.tween_callback(set_not_cooldown)
		
func set_not_cooldown():
	is_base_skill_cooldown = false
	
func move_along_path(path):
	current_path = path
	current_point = path[0]
	
	await arrived_at_path

func _on_dash_timer_timeout():
	is_dashing = false
	bump_detection.disabled = true
