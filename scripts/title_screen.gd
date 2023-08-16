extends Node2D

@onready var animation = $Animation
@onready var camera = $Camera

# Called when the node enters the scene tree for the first time.
func _ready():
	animation.play('title_enterance')
	await get_tree().create_timer(1.5).timeout
	animation.play('floating')

func shake_impact():
	camera.shake_for(0.2)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_play_pressed():
	animation.play('transition')
	await animation.animation_finished
	get_tree().change_scene_to_file('res://scenes/loader.tscn')
