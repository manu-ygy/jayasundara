extends StaticBody2D

signal item_taken

@onready var player = $/root/Loader/World/TileMap/Player
@onready var information = $/root/Loader/World/UI/Information

var player_inside = false

func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _input(event):
	if (Input.is_action_just_released('interact') and player_inside):
		emit_signal('item_taken')
		hide()

func _on_pick_area_body_entered(body):
	if (body == player):
		player_inside = true
		information.text = 'Tekan E untuk mengambil.'
		information.show()

func _on_pick_area_body_exited(body):
	if (body == player):
		player_inside = false
		information.hide()
