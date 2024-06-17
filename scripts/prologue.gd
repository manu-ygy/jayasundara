extends Node

@onready var cutscene_animation = $/root/Loader/Cutscenes/Animation
@onready var cloud_animation = $/root/Loader/Cutscenes/Scene1/CloudAnimation
@onready var camera = $/root/Loader/Camera

func _ready():
	#cutscene_animation.play('scene1')
	#await get_tree().create_timer(2.1).timeout
	#cloud_animation.play('cloud')

	#camera.shake_amount = 0.5
	#cutscene_animation.play('scene2')
	#await get_tree().create_timer(5).timeout
	#camera.shake_amount = 1
	#await get_tree().create_timer(0.5).timeout
	#cutscene_animation.play('scene2_idle')
	
	cutscene_animation.play('scene3')
