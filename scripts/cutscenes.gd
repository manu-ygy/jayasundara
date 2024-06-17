extends Node2D

@onready var clouds = $Scene1/Clouds 
@onready var camera = $/root/Loader/World/Tilemap/Riani/Camera

var base_viewport = Vector2(288, 162)
var default_cloud_position
var viewport_width

func _ready():
	resize_camera()
	get_tree().get_root().connect("size_changed", resize_camera)
	
	
	var default_cloud_position = $Scene1/Clouds/CloudMid.position.x
	
	for cloud in clouds.get_children():
		var cloud_clone = Sprite2D.new()
		cloud_clone.texture = cloud.texture
		cloud_clone.position = cloud.position - Vector2(cloud.texture.get_size().x, 0)
		cloud_clone.name = cloud.name + 'Clone'
		cloud_clone.flip_h = true
		cloud_clone.z_index = cloud.z_index
		
		clouds.add_child(cloud_clone)
	
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
			
func resize_camera():
	viewport_width = get_viewport_rect().size.x
	var zoom_size = get_viewport_rect().size.x / base_viewport.x
	zoom_size = Vector2(zoom_size, zoom_size)
	camera.zoom = zoom_size
