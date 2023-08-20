extends StaticBody2D

@onready var world = $/root/Loader/World
@onready var player = $/root/Loader/World/TileMap/Player
@onready var label = $Label

var hp = 99999
var movement_speed = 250
var is_stunned = false
var state = 'attacking'

var fireball_instance = load('res://scenes/attacks/fireball.tscn')
var shard_instance = load('res://scenes/attacks/ice_shard.tscn')

func _ready():
	add_to_group('enemy')

func attacked(damage):
	var tween = get_tree().create_tween()
		
	tween.tween_property($Sprite2D, 'self_modulate', Color(0.8, 0, 0, 1), 0.2)
	tween.tween_property($Sprite2D, 'self_modulate', Color(1, 1, 1, 1), 0.2)
	
	hp -= damage
	if (hp < 0):
		world.end_battle()
		return
	
	label.text = 'HP: ' + str(hp)

func _on_attack_timer_timeout():
	if (!is_stunned and state == 'attacking'):
		var fireball = fireball_instance.instantiate()
		fireball.global_position = global_position
		world.add_child(fireball)
		fireball.init(global_position.direction_to(player.global_position), self)

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
