extends Node

@onready var ui = get_parent()
@onready var player = $/root/Loader/World/TileMap/Player

func _ready():
	await get_tree().create_timer(0.2).timeout
	action('transfered')
	
func npc(name):
	return $/root/Loader/World/TileMap.get_node(name)

func action(name):
	match(name):
		'transfered':
			player.move(-1151, 216)
			
			player.is_stunned = true
			await ui.dialog('Riani', tr('LINE_PLAYER_1'))
			await ui.dialog('Riani', tr('LINE_PLAYER_2'))
			
			await player.move_along_path([Vector2(-1151, 304)])
			
			await ui.dialog('Raja', tr('LINE_BIANTARA_1'))
			await ui.dialog('Raja', tr('LINE_BIANTARA_2'))
			await ui.dialog('Raja', tr('LINE_BIANTARA_3'))
			
			await ui.dialog('Raja', tr('LINE_RAJA_1'))
			await ui.dialog('Raja', tr('LINE_RAJA_2'))
			await ui.dialog('Raja', tr('LINE_RAJA_3'))
			
			npc('King').align(Vector2.UP)
			
			player.glitch.show()
			await ui.dialog('Player', tr('LINE_PLAYER_5'))
			player.glitch.hide()
			
			await ui.dialog('Raja', tr('LINE_RAJA_3'))
			await ui.dialog('Mahamantri', tr('LINE_MAHAMANTRI_1'))
			await ui.dialog('Player', tr('LINE_PLAYER_56'))
			await ui.dialog('Mahamantri', tr('LINE_MAHAMANTRI_2'))
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
