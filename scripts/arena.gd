extends Node2D

signal battle_ended

@onready var player = $TileMap/Player
@onready var enemy = $TileMap/Enemy

@onready var end_message = $UI/EndMessage

@onready var ui = $UI
@onready var enterance = $Enterance
@onready var player_label = $Enterance/Profile/Wrapper/PlayerContainer/PlayerProfile/PlayerName
@onready var enemy_label = $Enterance/Profile/Wrapper/EnemyContainer/EnemyProfile/EnemyName

var game_ended = false

# Called when the node enters the scene tree for the first time.
func initiate_battle(player_name, enemy_name):
	player_label.text = player_name
	enemy_label.text = enemy_name
	
	await get_tree().create_timer(3).timeout
	enterance.hide()

	player.is_stunned = false
	enemy.is_stunned = false
	
	ui.show()

func end_battle():
	end_message.show()
	
	game_ended = true
	player.set_physics_process(false)
	player.game_ended = true
	
	await get_tree().create_timer(3).timeout
	
	emit_signal('battle_ended')
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
