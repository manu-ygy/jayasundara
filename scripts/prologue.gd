extends Node
signal clicked
signal scene_changed

@onready var cutscene_animation = $/root/Loader/Cutscenes/Animation
@onready var cloud_animation = $/root/Loader/Cutscenes/Scene1/CloudAnimation
@onready var camera = $/root/Loader/Camera
@onready var cutscenes = $/root/Loader/Cutscenes
@onready var overlay = $/root/Loader/Cutscenes/UI/Overlay
@onready var description = $/root/Loader/Cutscenes/UI/Container/Label
@onready var chain_left = $/root/Loader/Cutscenes/Scene6/ChainLeft
@onready var chain_right = $/root/Loader/Cutscenes/Scene6/ChainRight

var fireworks_instance = load('res://scenes/fireworks.tscn')
var chain_instance = load('res://scenes/chain.tscn')

func _input(event):
	if (Input.is_action_just_pressed('left_click')):
		emit_signal('clicked')

func _ready():
	#show_scene(1)
	#description.text = 'Di luasnya semesta, berbagai versi pararel bumi ada dan hidup, dengan masing-masing takdir dan cerita mereka sendiri.'
	#cutscene_animation.play('scene1')
	#await get_tree().create_timer(2.1).timeout
	#cloud_animation.play('cloud')
	#await clicked
#
	#show_scene(2)
	#await get_tree().create_timer(1).timeout
	#description.text = 'Peradaban-peradaban tersebut saling terhubung, memupuk harmoni dan bertumbuh bersama.'
	#camera.shake_amount = 0.5
	#cutscene_animation.play('scene2')
	#await get_tree().create_timer(5).timeout
	#camera.shake_amount = 1
	#await get_tree().create_timer(0.5).timeout
	#cutscene_animation.play('scene2_idle')
	#await clicked
	#
	#show_scene(3)
	#await get_tree().create_timer(1).timeout
	#description.text = 'Kemakmuran, kemajuan teknologi, dan kebijaksanaan berhasil mereka raih bersama-sama. '
	#cutscene_animation.play('scene3')
	#await get_tree().create_timer(1.7).timeout
	#camera.shake_amount = 0.5
	#await get_tree().create_timer(0.8).timeout
	#camera.shake_amount = 1
	#await get_tree().create_timer(1.5).timeout
	#cutscene_animation.play('scene3_idle')
	#await clicked
	
	#show_scene(4)
	#await get_tree().create_timer(1).timeout
	#cutscene_animation.play('scene4')
	#await get_tree().create_timer(5).timeout
	#cutscene_animation.play('scene4_idle')
	#await clicked
	
	#
	#show_scene(5)
	#await get_tree().create_timer(1).timeout
	#cutscene_animation.play('scene5')
	#await get_tree().create_timer(5).timeout
	#cutscene_animation.play('scene5_idle')
	#await clicked
	
	#show_scene(6)
	#chain_left.connect('chain_ended', spawn_chain.bind(-224))
	#chain_right.connect('chain_ended', spawn_chain.bind(-88))
	#await get_tree().create_timer(1).timeout
	#cutscene_animation.play('scene6')
	#await get_tree().create_timer(5).timeout
	#cutscene_animation.play('scene6_idle')
	#await clicked
	
	show_scene(7)
	await get_tree().create_timer(1).timeout
	cutscene_animation.play('scene7')
	
func show_scene(number):
	if (number != 1):
		var tween = get_tree().create_tween()
		tween.tween_property(overlay, 'modulate:a', 1, 1)
		await get_tree().create_timer(1).timeout
		
	for child in cutscenes.get_children():
		if (child is Node2D):
			if (child.name.replace('Scene', '') == str(number)):
				child.show()
			else:
				child.hide()

func spawn_fireworks():
	# -40, -256
	for x in range(3):
		var fireworks = fireworks_instance.instantiate()
		cutscenes.get_node('Scene3').add_child(fireworks)
		fireworks.global_position = Vector2(randf_range(-40, -256), 40)
		await get_tree().create_timer(0.25).timeout
		
func spawn_chain(position):
	var chain = chain_instance.instantiate()
	cutscenes.get_node('Scene6').add_child(chain)
	chain.global_position = Vector2(position, -280)
	chain.connect('chain_ended', spawn_chain.bind(position))
