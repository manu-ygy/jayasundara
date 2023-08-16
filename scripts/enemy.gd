extends StaticBody2D

@onready var world = $/root/Loader/World
@onready var player = $/root/Loader/World/TileMap/Player
@onready var label = $Label

var hp = 99999
var is_stunned = false

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
	if (!is_stunned):
		var shard = shard_instance.instantiate()
		shard.global_position = global_position
		world.add_child(shard)
		shard.init(global_position.direction_to(player.global_position), self)
		
		var fireball = fireball_instance.instantiate()
		fireball.global_position = global_position
		world.add_child(fireball)
		fireball.init(global_position.direction_to(player.global_position), self)

