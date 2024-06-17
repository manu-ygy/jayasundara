extends Node2D

@onready var animation = $Animation
@onready var ui = $UI
@onready var camera = $Camera
@onready var clouds = $Title/Clouds

var base_viewport = Vector2(288, 162)
var default_cloud_position
var viewport_width

func _ready():
	resize_camera()
	get_tree().get_root().connect("size_changed", resize_camera)
	
	default_cloud_position = clouds.get_node('CloudMid').position.x
	
	for cloud in clouds.get_children():
		var cloud_clone = Sprite2D.new()
		cloud_clone.texture = cloud.texture
		cloud_clone.position = cloud.position - Vector2(cloud.texture.get_size().x, 0)
		cloud_clone.name = cloud.name + 'Clone'
		cloud_clone.flip_h = true
		cloud_clone.z_index = cloud.z_index
		
		clouds.add_child(cloud_clone)
	
	animation.play('title_enterance')
	await get_tree().create_timer(2).timeout
	animation.play('floating')
	
func _process(_delta):
	for cloud in clouds.get_children():
		var speed = 0
		if ('Front' in cloud.name):
			speed = 0.3
		if ('Mid' in cloud.name):
			speed = 0.7
		if ('Back' in cloud.name):
			speed = 0.5
		
		cloud.position.x += speed
		
		if (cloud.position.x > viewport_width + cloud.texture.get_size().x / 2 + 32):
			var pair_name
			var clone_value = 0
			if ('Clone' in cloud.name):
				pair_name = cloud.name.replace('Clone', '')
			else:
				pair_name = cloud.name + 'Clone'
				clone_value += speed
				
			cloud.position.x = clouds.get_node(pair_name).position.x - cloud.texture.get_size().x + clone_value

func shake_impact():
	camera.shake_for(0.2)

func _on_play_pressed():
	animation.play('transition')
	await animation.animation_finished
	get_tree().change_scene_to_file('res://scenes/loader.tscn')

func resize_camera():
	viewport_width = get_viewport_rect().size.x
	var zoom_size = get_viewport_rect().size.x / base_viewport.x
	zoom_size = Vector2(zoom_size, zoom_size)
	camera.zoom = zoom_size
	
#	for element in ui.get_children():
#		element.scale = zoom_size
