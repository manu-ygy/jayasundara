extends Node2D

@onready var animation = $Animation
@onready var ui = $UI
@onready var camera = $Camera

var base_viewport = Vector2(288, 162)

func _ready():
	get_tree().get_root().connect("size_changed", resize_camera)
	
	animation.play('title_enterance')
	await get_tree().create_timer(1.5).timeout
	animation.play('floating')

func shake_impact():
	camera.shake_for(0.2)

func _on_play_pressed():
	animation.play('transition')
	await get_tree().create_timer(0.5)
	get_tree().change_scene_to_file('res://scenes/loader.tscn')
	await animation.animation_finished

func resize_camera():
	var zoom_size = get_viewport_rect().size.x / base_viewport.x
	zoom_size = Vector2(zoom_size, zoom_size)
	camera.zoom = zoom_size
	
	for element in ui.get_children():
		element.scale = zoom_size
