extends Area2D

@onready var player = $/root/Loader/World/TileMap/Player
@onready var overlay = $/root/Loader/World/Overlay
@onready var overlay_color = $/root/Loader/World/Overlay/Color
@onready var information = $/root/Loader/World/UI/Information

@export var is_activated = false
@export var destination: Vector2

var is_player_inside = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _input(event):
	if (is_player_inside and Input.is_action_just_released('interact')):
		overlay.show()
		var tween = get_tree().create_tween()
		tween.tween_property(overlay_color, 'color', Color(0, 0, 0, 1), 0.5)
		await get_tree().create_timer(0.5).timeout
		
		player.move(destination)
		
		tween = get_tree().create_tween()
		tween.tween_property(overlay_color, 'color', Color(0, 0, 0, 0), 0.5)
		await tween.finished

func _on_body_entered(body):
	if (body == player):
		is_player_inside = true
		information.show()
		information.text = 'Tekan E untuk masuk.'

func _on_body_exited(body):
	if (body == player):
		is_player_inside = false
		information.hide()
