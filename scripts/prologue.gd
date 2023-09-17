extends Node

@onready var tilemap = $/root/Loader/World/TileMap
@onready var riani = tilemap.get_node('Riani')
@onready var sanjaya = tilemap.get_node('Sanjaya')
@onready var ui = get_parent()
@onready var camera = riani.get_node('Camera')
@onready var enterance_animation = $/root/Loader/World/EnteranceAnimation

func shake_impact():
	camera.shake_for(0.2)

# Called when the node enters the scene tree for the first time.
func _ready():
	TranslationServer.set_locale('su')
	
	riani.move_along_path([Vector2(-40, -64)])
	await get_tree().create_timer(0.5).timeout
	await sanjaya.move_along_path([Vector2(-72, -64)])
	
	await ui.dialog('Sanjaya', tr('LINE_SANJAYA_1'))
	
	riani.align(Vector2.LEFT)
	await ui.dialog('Riani', tr('LINE_RIANI_1'))
	await ui.dialog('Sanjaya', tr('LINE_SANJAYA_2'))
	
	riani.move_along_path([Vector2(112, -64)])
	await get_tree().create_timer(0.5).timeout
	await sanjaya.move_along_path([Vector2(80, -64)])
	
	riani.align(Vector2.UP)
	sanjaya.align(Vector2.UP)
	await ui.dialog('Riani', tr('LINE_RIANI_2'))
	await ui.dialog('Sanjaya', tr('LINE_SANJAYA_2'))
	await ui.dialog('Riani', tr('LINE_RIANI_3'))
	
	riani.move_along_path([Vector2(272, -64), Vector2(272, -96)])
	await get_tree().create_timer(0.5).timeout
	await sanjaya.move_along_path([Vector2(240, -64), Vector2(240, -96)])
	
	await ui.dialog('Riani', tr('LINE_RIANI_4'))
	await ui.dialog('Sanjaya', tr('LINE_SANJAYA_3'))
	await ui.dialog('Riani', tr('LINE_RIANI_5'))
	
	await riani.move_along_path([Vector2(320, -96), Vector2(320, -152), Vector2(288, -152)])
	
	await ui.dialog('Riani', tr('LINE_RIANI_6'))
	await ui.dialog('Sanjaya', tr('LINE_SANJAYA_4'))
	
	riani.get_node('Glitch').show()
	sanjaya.get_node('Glitch').show()
	
	camera.shake_amount = 3
	camera.shake_for(2)
	enterance_animation.play('enterance')
	
	await get_tree().create_timer(2).timeout

	riani.move(144, 81)
	
	await get_tree().create_timer(7.5).timeout
	get_tree().change_scene_to_file('res://scenes/loader.tscn')
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
