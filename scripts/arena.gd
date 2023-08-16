extends Node2D

signal battle_ended

@onready var player = $TileMap/Player
@onready var end_message = $UI/EndMessage

var game_ended = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

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
