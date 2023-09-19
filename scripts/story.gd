extends Node

@onready var ui = get_parent()
@onready var player = $/root/Loader/World/TileMap/Player
@onready var overlay = $/root/Loader/World/Overlay
@onready var overlay_color = $/root/Loader/World/Overlay/Color

func _ready():
	TranslationServer.set_locale('id')
	
	#await get_tree().create_timer(0.2).timeout
	#action('transfered')
	
func npc(name):
	return $/root/Loader/World/TileMap.get_node(name)
	
func show_overlay(duration):
	overlay.show()
	
	var tween = get_tree().create_tween()
	tween.tween_property(overlay_color, 'color', Color(0, 0, 0, 0), 0.5)
	await get_tree().create_timer(duration).timeout
	
	tween = get_tree().create_tween()
	tween.tween_property(overlay_color, 'color', Color(0, 0, 0, 0), 0.5)
	await tween.finished

func action(name):
	match(name):
		'transfered':
			player.move(-1151, 216)
			
			player.is_stunned = true
			await ui.dialog('Riani', tr('LINE_PLAYER_1'))
			await ui.dialog('Riani', tr('LINE_PLAYER_2'))
			
			await player.move_along_path([Vector2(-1152, 368)])
			
			await ui.dialog('Raja', tr('LINE_BIANTARA_1'))
			await ui.dialog('Raja', tr('LINE_BIANTARA_2'))
			await ui.dialog('Raja', tr('LINE_BIANTARA_3'))
			
			await ui.dialog('Raja', tr('LINE_RAJA_1'))
			await ui.dialog('Raja', tr('LINE_RAJA_2'))
			await ui.dialog('Raja', tr('LINE_RAJA_3'))
			
			npc('King').align(Vector2.UP)
			npc('GrandMinister').align(Vector2.UP)
			npc('Guard1').align(Vector2.UP)
			npc('Guard2').align(Vector2.UP)
			
			player.glitch.show()
			await ui.dialog('Player', tr('LINE_PLAYER_5'))
			player.glitch.hide()
			
			await npc('King').move_along_path([Vector2(-1152, 421)])
			npc('King').align(Vector2.RIGHT)
			await ui.dialog('Raja', tr('LINE_RAJA_4'))
			
			npc('GrandMinister').align(Vector2.LEFT)
			
			await ui.dialog('Mahamantri', tr('LINE_MAHAMANTRI_1'))
			
			npc('King').align(Vector2.UP)
			await npc('GrandMinister').move_along_path([Vector2(-1128, 397)])
			
			await ui.dialog('Player', tr('LINE_PLAYER_6'))
			await ui.dialog('Mahamantri', tr('LINE_MAHAMANTRI_2'))
			
			npc('GrandMinister').move_along_path([Vector2(-1128, 128)])
			await get_tree().create_timer(0.5).timeout
			player.move_along_path([Vector2(-1152, 128)])
			
			await get_tree().create_timer(1).timeout
			
			await show_overlay(1)
			
			await ui.dialog('Mahamantri', tr('LINE_MAHAMANTRI_3'))
			await ui.dialog('Player', tr('LINE_PLAYER_7'))
			await ui.dialog('Mahamantri', tr('LINE_MAHAMANTRI_4'))
			await ui.dialog('Mahamantri', tr('LINE_MAHAMANTRI_5'))
			await ui.dialog('Mahamantri', tr('LINE_MAHAMANTRI_6'))
			await ui.dialog('Player', tr('LINE_PLAYER_8'))
			await ui.dialog('Mahamantri', tr('LINE_MAHAMANTRI_7'))
			await ui.dialog('Mahamantri', tr('LINE_MAHAMANTRI_8'))
			await ui.dialog('Player', tr('LINE_PLAYER_9'))
			await ui.dialog('Player', tr('LINE_PLAYER_10'))
			await ui.dialog('Mahamantri', tr('LINE_MAHAMANTRI_9'))
			await ui.dialog('Mahamantri', tr('LINE_MAHAMANTRI_10'))
			await ui.dialog('Mahamantri', tr('LINE_MAHAMANTRI_11'))
			await ui.dialog('Player', tr('LINE_PLAYER_11'))
			await ui.dialog('Mahamantri', tr('LINE_MAHAMANTRI_12'))
			await ui.dialog('Player', tr('LINE_PLAYER_12'))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
