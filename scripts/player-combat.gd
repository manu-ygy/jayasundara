extends CharacterBody2D

@onready var world = $/root/Loader/World/TileMap

@onready var animation = $Animation
@onready var dash_timer = $DashTimer
@onready var attack_timer = $AttackTimer
@onready var bump_detection = $Area2D/CollisionShape2D
@onready var muzzle = $Muzzle
@onready var raycast = $Muzzle/RayCast2D
@onready var indicator = $Indicator
@onready var enemy = $/root/Loader/World/TileMap/Enemy

@onready var ui = $/root/Loader/World/UI
@onready var mp_bar = $/root/Loader/World/UI/Wrapper/Status/Player/MPBar

@onready var camera = $Camera2D

var fireball_instance = load('res://scenes/attacks/fireball.tscn')
var pillar_instance = load('res://scenes/attacks/earth_pilllar.tscn')
var prison_instance = load('res://scenes/attacks/water_prison.tscn')
var shard_instance = load('res://scenes/attacks/ice_shard.tscn')
var dust_instance = load('res://dash.tres')

var mp = 100
var hp = 100

var game_ended = false

var movement_speed = 125
var dash_speed = 450

var attack_direction = Vector2.ZERO
var quick_cast = 'earth_pillar'

var current_combinations = []
var attack_combinations = {
	'fireball': [KEY_1, KEY_2],
	'earth_pillar': [KEY_1, KEY_3],
	'water_prison': [KEY_2, KEY_3],
	'ice_shard': [KEY_1, KEY_4]
}

var is_dashing = false
var is_stunned = false
var is_attacking = false

var last_ghost_pos = Vector2()

func _physics_process(delta):
	var direction = Input.get_vector('left', 'right', 'up', 'down')
	var speed = dash_speed if is_dashing else movement_speed
	velocity = direction * speed if !is_stunned else Vector2.ZERO 
	
	attack_direction = global_position.direction_to(enemy.global_position)
	
	if (!is_attacking):
		if (velocity == Vector2.ZERO):
			animation.play('idle')
		else:
			animation.flip_h = velocity.x <= 0
			muzzle.rotation = attack_direction.angle()
			# indicator.rotation = attack_direction.angle()
			# indicator.skew = (indicator.rotation_degrees - floor(indicator.rotation_degrees / 45) * 45)
			
			# indicator.skew = attack_direction.angle()
			
			if (is_dashing):
				animation.play('dash')
			else:
				animation.play('walk')
	else:
		animation.flip_h = attack_direction.x <= 0
		animation.play('attack')
	
	move_and_slide()
	
func _input(event):
	if (Input.is_action_just_pressed('base_skill') and !is_dashing and velocity != Vector2.ZERO and !game_ended):
		is_dashing = true
		bump_detection.disabled = false
		dash_timer.start()
		
#		var dust = AnimatedSprite2D.new()
#		dust.global_position = global_position
#		dust.sprite_frames = dust_instance
#		dust.rotation = velocity.angle()
#		dust.play('default')
#		dust.connect('animation_finished', dust.queue_free)
		
#		world.add_child(dust)
		
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
				
	elif (Input.is_action_just_pressed('quick_cast') and !game_ended):
		cast_attack(quick_cast)
		
	elif (event is InputEventKey and event.pressed and !game_ended):
		if event.keycode in [KEY_1, KEY_2, KEY_3, KEY_4, KEY_5, KEY_6, KEY_7, KEY_8, KEY_9]:
			current_combinations.append(event.keycode)
			
			cast_attack(find_combinations())
		else:
			current_combinations = []
			return
			
func cast_attack(attack_name):
	mp -= 2
	# mp_bar.value = mp

	is_attacking = true
	attack_timer.start()
		
	await get_tree().create_timer(0.2).timeout

	match (attack_name):
		'fireball': 
			var fireball = fireball_instance.instantiate()
			fireball.global_position = global_position
			world.add_child(fireball)
			fireball.init(attack_direction, self)
			
		'earth_pillar':
			if (!raycast.is_colliding()):
				var pillar = pillar_instance.instantiate()
				pillar.global_position = global_position
				world.add_child(pillar)
				pillar.init(attack_direction, self)
				# pillar.add_to_group('particle')
				
		'water_prison':
			var prison = prison_instance.instantiate()
			prison.global_position = global_position
			world.add_child(prison)
			prison.init(attack_direction)
			# prison.add_to_group('particle')
			
		'ice_shard':
			var shard = shard_instance.instantiate()
			shard.global_position = global_position
			world.add_child(shard)
			shard.init(attack_direction, self)
			
		'meteor':
			await get_tree().create_timer(1).timeout
			
			for x in range(5):
				await get_tree().create_timer(0.5).timeout
				
				var firing_position = global_position - Vector2(0, 64)
				var fireball = fireball_instance.instantiate()
				
				fireball.global_position = firing_position
				world.add_child(fireball)
				fireball.init(firing_position.direction_to(enemy.global_position), self)
			
		_:
			return
			
	current_combinations = []

func find_combinations():
	var index = attack_combinations.values().find(current_combinations)
	return attack_combinations.keys()[index] if index != -1 else null

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

func _on_glitch_timer_timeout():
#	glitch.show()
#	await get_tree().create_timer(2).timeout
#	glitch.hide()
	pass
