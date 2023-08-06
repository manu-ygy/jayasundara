extends StaticBody2D

@onready var world = $/root/World
@onready var player = $/root/World/TileMap/Player
@onready var label = $Label

var hp = 99999

var fireball_instance = load('res://attacks/fireball.tscn')

func _ready():
	add_to_group('enemy')

func attacked(damage):
	var tween = get_tree().create_tween()
		
	tween.tween_property($Sprite2D, 'self_modulate', Color(0.8, 0, 0, 1), 0.2)
	tween.tween_property($Sprite2D, 'self_modulate', Color(1, 1, 1, 1), 0.2)
	
	hp -= damage
	label.text = 'HP: ' + str(hp)

func _on_attack_timer_timeout():
	for x in range(5):
		var fireball = fireball_instance.instantiate()
		fireball.global_position = global_position
		world.add_child(fireball)
		fireball.init(global_position.direction_to(player.global_position), self)
		
		await get_tree().create_timer(0.2).timeout
