extends CharacterBody2D

signal casting(what)

@onready var world = $/root/Loader/World/TileMap

@onready var animation = $Animation
@onready var dash_timer = $DashTimer
@onready var attack_timer = $AttackTimer
@onready var regen_timer = $RegenTimer
@onready var bump_detection = $Area2D/CollisionShape2D
@onready var muzzle = $Muzzle
@onready var raycast = $Muzzle/RayCast2D
@onready var indicator = $Indicator
@onready var enemy = $/root/Loader/World/TileMap/Enemy

@onready var ui = $/root/Loader/World/UI
@onready var mp_bar = $/root/Loader/World/UI/Wrapper/Status/Player/MPBar
@onready var base_skill_progress = $/root/Loader/World/UI/Stat/BaseSkill
@onready var combo = $/root/Loader/World/UI/Combo

@onready var click_timer = get_node_or_null('ClickTimer')

@onready var camera = $Camera2D

var fireball_instance = load('res://scenes/attacks/fireball.tscn')
var pillar_instance = load('res://scenes/attacks/earth_pillar.tscn')
var push_instance = load('res://scenes/attacks/earth_push.tscn')
var shard_instance = load('res://scenes/attacks/ice_shard.tscn')
var summoning_instance = load('res://scenes/attacks/summoning.tscn')
var tracking_instance = load('res://scenes/attacks/tracking.tscn')
var lantern_instance = load('res://scenes/attacks/lantern.tscn')
# var dust_instance = load('res://dash.tres')

@export var mp = 150
@export var hp = 100

var game_ended = false

var default_speed = 125
var movement_speed = default_speed
var dash_speed = 450
var is_levitating = false

var allow_regen = false

var attack_direction = Vector2.ZERO
var quick_cast = 'fireball'

var current_combinations = []
var attack_combinations = {
	'fireball': [0],
	'earth_pillar': [1],
	'summoning': [2],
	'ice_shard': [3],
	'levitation': [4],
	'tracking': [5],
	'lantern': [6],
	'earth_push': [1, 0]
}

var is_dashing = false
var is_stunned = true
var is_attacking = false

var base_skill_cooldown = 2
var is_base_skill_cooldown = false

var last_ghost_pos = Vector2()

var attack_tween
var mouse_button_pressed = false

func _physics_process(delta):
	var direction = Input.get_vector('left', 'right', 'up', 'down')
	var speed = dash_speed if is_dashing else movement_speed
	velocity = direction * speed if !is_stunned else Vector2.ZERO 
	
	attack_direction = global_position.direction_to(get_global_mouse_position())
	
	if (Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and !mouse_button_pressed):
		mouse_button_pressed = true

		click_timer.start()

		attack_tween = get_tree().create_tween()
		attack_tween.tween_property(base_skill_progress, 'value', 100, 0.2)
	
	if (mouse_button_pressed and !Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)):
		mouse_button_pressed = false
		attack_tween.stop()
		
		if (click_timer.time_left <= 0.05): 
			current_combinations.append(1)
		else:
			current_combinations.append(0)
	
		base_skill_progress.value = 0
		click_timer.stop()
	
		combo.text = '-'.join(current_combinations)
	
		cast_attack(find_combinations())
	
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
				if (!is_levitating):
					animation.play('walk')
				else:
					animation.play('dash')
	else:
		animation.flip_h = attack_direction.x <= 0
		# animation.play('attack')
	
	move_and_slide()
	
func _input(event):
	#if (Input.is_action_just_pressed('base_skill') and !is_dashing and !is_base_skill_cooldown and velocity != Vector2.ZERO and !game_ended):
	if (false):
		is_base_skill_cooldown = true
		base_skill_progress.value = 0
		
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
				ghost.z_index = 1
				ghost.z_as_relative = false
				
				var tween = get_tree().create_tween()
				tween.tween_property(ghost, 'modulate', Color(1, 1, 1, 0), 0.2)
				tween.tween_callback(ghost.queue_free)
				
				last_ghost_pos = global_position
				
				world.add_child(ghost)
				
		#var tween = get_tree().create_tween()
		#tween.tween_property(base_skill_progress, 'value', 100, base_skill_cooldown)
		#tween.tween_callback(set_not_cooldown)
				
	#elif (Input.is_action_just_pressed('quick_cast') and !game_ended):
		#cast_attack(quick_cast)
		#
	#elif (Input.is_action_pressed('left_click') or Input.is_action_pressed('right_click')):
		#base_skill_progress.value = 0
		#click_timer.wait_time = 0.2
		#click_timer.start()
		#
		#attack_tween = get_tree().create_tween()
		#attack_tween.tween_property(base_skill_progress, 'value', 100, 0.2)
		
	#elif (Input.is_action_just_released('left_click') or Input.is_action_just_released('right_click')):
		#var time_left = click_timer.time_left
		#click_timer.stop()
		#
		#if (time_left <= 0.05): 
			#current_combinations.append(1)
		#else:
			#current_combinations.append(0)
			#
		#attack_tween.stop()
		#base_skill_progress.value = 0
		#
		#print(current_combinations)
		#cast_attack(find_combinations())

func set_not_cooldown():
	is_base_skill_cooldown = false
			
func attacked(damage):
	allow_regen = false
	regen_timer.start()
	
	hp -= damage
	ui.update_hp_bar(hp)
			
func cast_attack(attack_name):
	is_attacking = true
		
	attack_timer.start()
	if (attack_name):
		animation.play('attack')
		emit_signal('casting', attack_name)
		await get_tree().create_timer(0.2).timeout
	
	if (!is_levitating):
		match (attack_name):
			'fireball': 
				var fireball = fireball_instance.instantiate()
				fireball.global_position = global_position
				world.add_child(fireball)
				fireball.init(attack_direction, self)
				
				mp -= 20
				ui.update_mp_bar(mp)
				
			'earth_pillar':
				if (!raycast.is_colliding()):
					var pillar = pillar_instance.instantiate()
					pillar.global_position = global_position
					world.add_child(pillar)
					pillar.init(attack_direction, self)
					# pillar.add_to_group('particle')
					
					mp -= 30
					ui.update_mp_bar(mp)
					
			'earth_push':
				print('earth push')
				if (!raycast.is_colliding()):
					var push = push_instance.instantiate()
					push.global_position = global_position
					world.add_child(push)
					push.init(attack_direction, self)
					# pillar.add_to_group('particle')
					
					mp -= 30
					ui.update_mp_bar(mp)
				
			'ice_shard':
				var shard = shard_instance.instantiate()
				shard.global_position = global_position
				world.add_child(shard)
				shard.init(attack_direction, self)
				
				mp -= 15
				ui.update_mp_bar(mp)
				
			'meteor':
				await get_tree().create_timer(1).timeout
				
				for x in range(5):
					await get_tree().create_timer(0.5).timeout
					
					var firing_position = global_position - Vector2(0, 64)
					var fireball = fireball_instance.instantiate()
					
					fireball.global_position = firing_position
					world.add_child(fireball)
					fireball.init(firing_position.direction_to(enemy.global_position), self)
					
				animation.play('attack')
				
			'levitation':
				is_levitating = true

				animation.position.y = -4
				movement_speed = default_speed * 2
			
			'tracking':
				var positions = [Vector2(0, -16), Vector2(16, -8), Vector2(-16, -8), Vector2(16, 8), Vector2(-16, 8)]
				
				for x in range(5):
					var tracking = tracking_instance.instantiate()
					tracking.global_position = global_position + positions[x]
					world.add_child(tracking)
					
					tracking.init(attack_direction, self, enemy)
					
			'lantern':
				var lantern = lantern_instance.instantiate()
				lantern.global_position = global_position
				world.add_child(lantern)
				lantern.init(attack_direction, self)
			
			'summoning':
				var summoning = summoning_instance.instantiate()
				summoning.global_position = global_position
				world.add_child(summoning)
				summoning.init(attack_direction, self)
			
			_:
				return
				
		current_combinations = []
	else:
		if (attack_name == 'levitation'):
			is_levitating = false
			
			animation.position.y = 0
			movement_speed = default_speed

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

func _on_regen_timer_timeout():
	allow_regen = true

func _on_regen_tick_timeout():
	if (allow_regen):
		hp += 5
		
	if (!is_levitating):
		mp += 10
	else:
		mp -= 5
		
	ui.update_mp_bar(mp)
	ui.update_hp_bar(hp)
