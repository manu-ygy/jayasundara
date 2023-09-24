extends Area2D

signal player_entered

@onready var player = $/root/Loader/World/TileMap/Player

func _on_body_entered(body):
	if (body == player):
		emit_signal('player_entered')
