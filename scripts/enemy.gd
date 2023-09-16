extends CharacterBody2D

@onready var world = $/root/Loader/World
@onready var collision = $Collision
@onready var player = $/root/Loader/World/TileMap/Player
@onready var animation = $Animation
@onready var label = $Label

var hp = 500
var movement_speed = 100
var is_stunned = true
var game_ended = false
var state = 'wander'
var cycle = 0

var is_player_inside = false

var fireball_instance = load('res://scenes/attacks/fireball.tscn')
var shard_instance = load('res://scenes/attacks/ice_shard.tscn')
var summoning_instance = load('res://scenes/attacks/summoning.tscn')

var knockup_direction

func _ready():
	add_to_group('enemy')

func _physics_process(delta):
	if (!is_player_inside and !is_stunned):
		state = 'wander'
		velocity = global_position.direction_to(player.global_position) * movement_speed
	else:
		if (state != 'knockup'):
			state = 'attacking'
			velocity = Vector2.ZERO
		else:
			velocity = global_position.direction_to(knockup_direction) * 1000
	
	move_and_slide()

func attacked(damage):
	# var tween = get_tree().create_tween()
		
	# tween.tween_property($Sprite2D, 'self_modulate', Color(0.8, 0, 0, 1), 0.2)
	# tween.tween_property($Sprite2D, 'self_modulate', Color(1, 1, 1, 1), 0.2)
	
	hp -= damage
	if (hp < 0 and !game_ended):
		game_ended = true
		world.end_battle()
		return
	
	label.text = 'HP: ' + str(hp)
	
func calculate_arc_velocity(source_position, target_position, arc_height, gravity):
	var velocity = Vector2()
	var displacement = target_position - source_position
	
	if (displacement.y > arc_height):
		var time_up = sqrt(-2 * arc_height / float(gravity))
		var time_down = sqrt(2 * (displacement.y - arc_height) / float(gravity))
		
		velocity.y = -sqrt(-2 * gravity * arc_height)
		velocity.x = displacement.x / float(time_up + time_down)
		
	return velocity

func knockup(direction):
	knockup_direction = direction
	velocity = calculate_arc_velocity(global_position, knockup_direction, 32, 0)
	
	collision.disabled = true
	
	state = 'knockup'
	is_stunned = true
	
	var tween = get_tree().create_tween()
	tween.tween_property(animation, 'position', Vector2(0, -16), 0.5).set_ease(Tween.EASE_OUT)
	tween.tween_property(animation, 'position', Vector2(0, 0), 0.5).set_ease(Tween.EASE_IN_OUT)
	
	await tween.finished
	is_stunned = false
	collision.disabled = false

func _on_attack_timer_timeout():
	if (!is_stunned and state == 'attacking'):
		var fireball = fireball_instance.instantiate()
		fireball.global_position = global_position
		world.add_child(fireball)
		fireball.init(global_position.direction_to(player.global_position), self)
		
#		cycle += 1
#
#		if (cycle == 10):
#			cycle = 0
#
#			var summoning = summoning_instance.instantiate()
#			summoning.global_position = global_position
#			world.add_child(summoning)
#			summoning.init(global_position.direction_to(player.global_position), self)

func _on_suprise_timer_timeout():
	state = 'suprising'
	is_stunned = false
	
	var previous_location = global_position
	global_position = player.global_position + (player.attack_direction * 40 * -1)
	
	for x in range(3):
		if (!is_stunned):
			var shard = shard_instance.instantiate()
			shard.global_position = global_position
			world.add_child(shard)
			shard.init(global_position.direction_to(player.global_position), self)
			await get_tree().create_timer(0.2).timeout
	
	await get_tree().create_timer(1).timeout
	
	state = 'attacking'
	
	if (!is_stunned):
		global_position = previous_location

func _on_attack_radius_body_entered(body):
	if (body == player):
		is_player_inside = true

func _on_attack_radius_body_exited(body):
	if (body == player):
		is_player_inside = false
