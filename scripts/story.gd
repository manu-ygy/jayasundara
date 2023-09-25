extends Node

@onready var ui = get_parent()
@onready var player = $/root/Loader/World/TileMap/Player
@onready var overlay = $/root/Loader/World/Overlay
@onready var overlay_color = $/root/Loader/World/Overlay/Color
@onready var camera = $/root/Loader/World/Camera
@onready var daycycle = $/root/Loader/World/DayCycle

@onready var house_detector = $/root/Loader/World/TileMap/Detector/HouseDetector

var player_name = 'Riani'
var player_two_name = 'Sanjaya'

func _ready():
	TranslationServer.set_locale('su')
	
	await get_tree().create_timer(0.2).timeout
	action('transfered')
	
func npc(name):
	return $/root/Loader/World/TileMap.get_node(name)
	
# localize string
func lzs(string):
	return tr(string).replace('[Player]', player_name).replace('[Player 2]', player_two_name)
	
func show_overlay(is_start = false, is_end = false):
	overlay.show()
	
	if (is_start):
		var tween = get_tree().create_tween()
		tween.tween_property(overlay_color, 'color', Color(0, 0, 0, 1), 0.5)
		await tween.finished
	
	if (is_end):
		var tween = get_tree().create_tween()
		tween.tween_property(overlay_color, 'color', Color(0, 0, 0, 0), 0.5)
		await tween.finished

func action(name):
	match(name):
		'transfered':
			player.move(-1152, 224)
			player.movement_speed = 75
			player.is_stunned = true
			
			npc('King').move(-1152, 437)
			npc('Guard1').move(-1203, 397)
			npc('Guard2').move(-1103, 397)
			npc('GrandMinister').move(-1128, 421)
			
			await ui.dialog('Riani', lzs('LINE_PLAYER_1'))
			await ui.dialog('Riani', lzs('LINE_PLAYER_2'))
			
			await player.move_along_path([Vector2(-1152, 368)])
			
			await ui.dialog('Raja', lzs('LINE_BIANTARA_1'))
			await ui.dialog('Raja', lzs('LINE_BIANTARA_2'))
			await ui.dialog('Raja', lzs('LINE_BIANTARA_3'))
			
			await ui.dialog('Raja', lzs('LINE_RAJA_1'))
			await ui.dialog('Raja', lzs('LINE_RAJA_2'))
			
			await ui.dialog(null, '(kretak)')
			await ui.dialog('Raja', lzs('LINE_RAJA_3'))
			
			npc('King').align(Vector2.UP)
			npc('GrandMinister').align(Vector2.UP)
			npc('Guard1').align(Vector2.UP)
			npc('Guard2').align(Vector2.UP)
			
			player.glitch.show()
			await ui.dialog('Player', lzs('LINE_PLAYER_5'))
			player.glitch.hide()
			
			await npc('King').move_along_path([Vector2(-1152, 421)])
			npc('King').align(Vector2.RIGHT)
			await ui.dialog('Raja', lzs('LINE_RAJA_4'))
			
			npc('GrandMinister').align(Vector2.LEFT)
			
			await ui.dialog('Mahamantri', lzs('LINE_MAHAMANTRI_1'))
			
			npc('King').align(Vector2.UP)
			await npc('GrandMinister').move_along_path([Vector2(-1128, 397)])
			
			await ui.dialog('Player', lzs('LINE_PLAYER_6'))
			await ui.dialog('Mahamantri', lzs('LINE_MAHAMANTRI_2'))
			
			npc('GrandMinister').move_along_path([Vector2(-1128, 128)])
			await get_tree().create_timer(0.6).timeout
			player.move_along_path([Vector2(-1152, 128)])
			
			await get_tree().create_timer(1.5).timeout
			
			action('arrived_at_library')
			
		'arrived_at_library':
			player.movement_speed = 75
			player.is_stunned = true
			
			await show_overlay(true)
			await get_tree().create_timer(0.5).timeout
			player.clear_path()
			npc('GrandMinister').clear_path()
			
			npc('King').hide()
			npc('Guard2').hide()
			
			player.move(-32, 1400)
			npc('GrandMinister').move(-64, 1400)
			await show_overlay(false, true)
			
			npc('GrandMinister').move_along_path([Vector2(-64, 1448), Vector2(-144, 1448), Vector2(-144, 1608), Vector2(-176, 1608)])
			await get_tree().create_timer(0.5).timeout
			
			await player.move_along_path([Vector2(-32, 1448), Vector2(-144, 1448), Vector2(-144, 1608)])
			
			npc('GrandMinister').align(Vector2.RIGHT)
			player.align(Vector2.LEFT)
			
			await ui.dialog('Mahamantri', lzs('LINE_MAHAMANTRI_3'))
			await ui.dialog('Player', lzs('LINE_PLAYER_7'))
			await ui.dialog('Mahamantri', lzs('LINE_MAHAMANTRI_4'))
			await ui.dialog('Mahamantri', lzs('LINE_MAHAMANTRI_5'))
			await ui.dialog('Mahamantri', lzs('LINE_MAHAMANTRI_6'))
			await ui.dialog('Player', lzs('LINE_PLAYER_8'))
			await ui.dialog('Mahamantri', lzs('LINE_MAHAMANTRI_7'))
			await ui.dialog('Mahamantri', lzs('LINE_MAHAMANTRI_8'))
			await ui.dialog('Player', lzs('LINE_PLAYER_9'))
			await ui.dialog('Player', lzs('LINE_PLAYER_10'))
			await ui.dialog('Mahamantri', lzs('LINE_MAHAMANTRI_9'))
			
			player.align(Vector2.UP)
			
			await npc('GrandMinister').move_along_path([Vector2(-176, 1528)])
			await get_tree().create_timer(2).timeout
			await npc('GrandMinister').move_along_path([Vector2(-176, 1608)])
			
			npc('GrandMinister').align(Vector2.RIGHT)
			player.align(Vector2.LEFT)
			
			await ui.dialog('Mahamantri', lzs('LINE_MAHAMANTRI_10'))
			await ui.dialog('Mahamantri', lzs('LINE_MAHAMANTRI_11'))
			await ui.dialog('Player', lzs('LINE_PLAYER_11'))
			await ui.dialog('Mahamantri', lzs('LINE_MAHAMANTRI_12'))
			await ui.dialog('Player', lzs('LINE_PLAYER_12'))
			await ui.dialog('Mahamantri', lzs('LINE_MAHAMANTRI_13'))
			
			ui.start_tutorial()
			await ui.battle_ended
			# await ui.start_battle('Riani', 'Mahamantri')
			
			await ui.dialog('Mahamantri', lzs('LINE_MAHAMANTRI_14'))
			
			npc('Guard1').movement_speed = 125
			npc('Guard1').move(-64, 1400)
			await npc('Guard1').move_along_path([Vector2(-64, 1448), Vector2(-144, 1448), Vector2(-144, 1576)])
			
			await ui.dialog('Penjaga', lzs('LINE_PENJAGA_1'))
			
			player.align(Vector2.UP)
			npc('GrandMinister').align(Vector2.UP)
			
			npc('Player2').show()
			await npc('Player2').move(-64, 1400)
			await npc('Player2').move_along_path([Vector2(-64, 1448), Vector2(-144, 1448), Vector2(-144, 1544), Vector2(-176, 1544), Vector2(-176, 1576)])
			
			await ui.dialog('Player', lzs('LINE_PLAYER_13'))
			await ui.dialog('Player2', lzs('LINE_PLAYER2_1'))
			await ui.dialog('Mahamantri', lzs('LINE_MAHAMANTRI_16'))
			await ui.dialog('Player', lzs('LINE_PLAYER_14'))
			await ui.dialog('Player2', lzs('LINE_PLAYER2_2'))
			await ui.dialog('Player', lzs('LINE_PLAYER_15'))
			await ui.dialog('Player', lzs('LINE_PLAYER_16'))
			await ui.dialog('Mahamantri', lzs('LINE_MAHAMANTRI_17'))
			
			await show_overlay(true)
			await get_tree().create_timer(0.5).timeout

			player.is_stunned = false
			player.movement_speed = 125
			
			player.move(-1164, 352)
			player.align(Vector2.DOWN)
			
			npc('Player2').move(-1132, 352)
			npc('Player2').align(Vector2.DOWN)
			npc('Player2').is_following_leader = true
			
			daycycle.animation.seek(17, true)
			
			await ui.update_mission('find_home', 'Cari rumah yang dimaksud oleh Mahamantri (berada sebelah timur istana).')
			ui.mission_container.show()
			
			await show_overlay(false, true)
			
			await house_detector.player_entered
			action('home_finded')
			
		'home_finded':
			player.is_stunned = true
			await ui.dialog('Player', lzs('Ternyata ini rumahnya.'))
			await ui.dialog('Player 2', lzs('Iya. Ayo kita masuk dan beristirahat.'))
			
			player.move_alonng_path([Vector2(196, 384)])
			await get_tree().create_timer(0,5).timeout
			
			await show_overlay(true)
			await get_tree().create_timer(1).timeout
			
			daycycle.animation.seek(8, true)
			
			player.move(196, 384)
			player.align(Vector2.DOWN)
			
			npc('Player2').move(220, 384)
			npc('Player2').align(Vector2.DOWN)
			npc('Player2').is_following_leader = true
			
			await show_overlay(false, true)
			
		'find_materials':
			await ui.dialog('Penjaga', lzs('LINE_PENJAGA_2'))
			await ui.dialog('Player2', lzs('LINE_PLAYER2_3'))
			
			await show_overlay(true)
			await get_tree().create_timer(0.5).timeout
			
			npc('Player2').move(-176, 1576)
			
			npc('GrandMinister').move(-144, 1608)
			npc('GrandMinister').align(Vector2.UP)
			
			player.move(-176, 1608)
			player.align(Vector2.UP)
			
			await show_overlay(false, true)
			
			await ui.dialog('Mahamantri', lzs('LINE_MAHAMANTRI_18'))
			await ui.dialog('Mahamantri', lzs('LINE_MAHAMANTRI_19'))
			await ui.dialog('Mahamantri', lzs('LINE_MAHAMANTRI_20'))
			await ui.dialog('Player', lzs('LINE_PLAYER_17'))
			
			await show_overlay(true)
			await get_tree().create_timer(0.5).timeout
			
			player.move(-1164, 352)
			player.align(Vector2.DOWN)
			
			npc('Player2').move(-1132, 352)
			npc('Player2').align(Vector2.DOWN)
			player.is_stunned = false
			
			await show_overlay(false, true)
			
		'outside_the_palace':
			npc('Player2').is_following_leader = true
			await ui.dialog('Player', lzs('Ayo, kita cari bahan-bahan yang diperlukan.'))
			await ui.dialog('Player2', lzs('Iya. Aku akan mengikutimu.'))
			
		'first_item_taken':
			await ui.dialog('Player', lzs('LINE_PLAYER_18'))
			await ui.dialog('Player2', lzs('LINE_PLAYER2_5'))
			await ui.dialog('Player', lzs('LINE_PLAYER_19'))
			await ui.dialog('Player2', lzs('LINE_PLAYER2_6'))
			await ui.dialog('Player', lzs('LINE_PLAYER_19'))
			
		'meet_farmer':
			await ui.dialog('Peternak', lzs('LINE_PETERNAK_1'))
			await ui.dialog('Player', lzs('LINE_PLAYER_20'))
			await ui.dialog('Peternak', lzs('LINE_PETERNAK_2'))
			
		'chicken_collected':
			await ui.dialog('Peternak', lzs('LINE_PETERNAK_3'))
			await ui.dialog('Peternak', lzs('LINE_PETERNAK_4'))
			await ui.dialog('Player2', lzs('LINE_PLAYER2_5'))
			await ui.dialog('Player', lzs('LINE_PLAYER_21'))
			await ui.dialog('Peternak', lzs('LINE_PETERNAK_6'))
			await ui.dialog('Player', lzs('LINE_PLAYER_22'))
			
		'meet_shaman':
			await ui.dialog('Dukun', lzs('LINE_DUKUN_1'))
			await ui.dialog('Player2', lzs('LINE_PLAYER2_6'))
			await ui.dialog('Player', lzs('LINE_PLAYER_23'))
			await ui.dialog('Dukun', lzs('LINE_DUKUN_2'))
			await ui.dialog('Dukun', lzs('LINE_DUKUN_3'))
			await ui.dialog('Player', lzs('LINE_PLAYER_24'))
			await ui.dialog('Dukun', lzs('LINE_DUKUN_4'))
			await ui.dialog('Player2', lzs('LINE_PLAYER2_7'))
			await ui.dialog('Player', lzs('LINE_PLAYER_25'))
			await ui.dialog('Player', lzs('LINE_PLAYER_26'))
			await ui.dialog('Dukun', lzs('LINE_DUKUN_5'))
			await ui.dialog('Player2', lzs('LINE_PLAYER2_8'))
			await ui.dialog('Dukun', lzs('LINE_DUKUN_6'))
			
		'all_collected':
			await ui.dialog('Player2', lzs('LINE_PLAYER2_8'))
			await ui.dialog('Mahamantri', lzs('LINE_MAHAMANTRI_21'))
			await ui.dialog('Mahamantri', lzs('LINE_MAHAMANTRI_22'))
			await ui.dialog('Mahamantri', lzs('LINE_MAHAMANTRI_23'))
			await ui.dialog('Player2', lzs('LINE_PLAYER2__9'))
			await ui.dialog('Player', lzs('LINE_PLAYER_27'))
			await ui.dialog('Mahamantri', lzs('LINE_MAHAMANTRI_24'))
			await ui.dialog('Player', lzs('LINE_PLAYER_28'))
			await ui.dialog('Player2', lzs('LINE_PLAYER2_10'))
			await ui.dialog('Player', lzs('LINE_PLAYER_29'))

		'arrived_at_temple':
			await ui.dialog('Kuil', lzs('LINE_KUIL_1'))
			await ui.dialog('Player', lzs('LINE_PLAYER_30'))
			await ui.dialog('Kuil', lzs('LINE_KUIL_2'))
			await ui.dialog('Player', lzs('LINE_PLAYER_31'))
			
		'arrived_at_temple_next_day':
			await ui.dialog('Kuil', lzs('LINE_KUIL_3'))
			await ui.dialog('Kuil', lzs('LINE_KUIL_4'))
			await ui.dialog('Pendeta', lzs('LINE_PENDETA_1'))
			await ui.dialog('Kuil', lzs('LINE_KUIL_5'))
			await ui.dialog('Pendeta', lzs('LINE_PENDETA_2'))
			await ui.dialog('Pendeta', lzs('LINE_PENDETA_3'))
			await ui.dialog('Player', lzs('LINE_PLAYER_32'))
			await ui.dialog('Pendeta', lzs('LINE_PENDETA_4'))
			await ui.dialog('Player', lzs('LINE_PLAYER_33'))
			await ui.dialog('Pendeta', lzs('LINE_PENDETA_5'))
			await ui.dialog('Player', lzs('LINE_PLAYER_34'))
			await ui.dialog('Pendeta', lzs('LINE_PENDETA_6'))
			await ui.dialog('Player2', lzs('LINE_PLAYER2_11'))
			await ui.dialog('Player2', lzs('LINE_PLAYER2_12'))
			await ui.dialog('Pendeta', lzs('LINE_PENDETA_7'))
			await ui.dialog('Player', lzs('LINE_PLAYER_35'))
			await ui.dialog('Pendeta', lzs('LINE_PENDETA_8'))
			await ui.dialog('Player', lzs('LINE_PLAYER_36'))
			await ui.dialog('Pendeta', lzs('LINE_PENDETA_9'))
			await ui.dialog('Player2', lzs('LINE_PLAYER2_13'))
			await ui.dialog('Pendeta', lzs('LINE_PENDETA_10'))
			await ui.dialog('Player2', lzs('LINE_PLAYER2_14'))
			await ui.dialog('Player', lzs('LINE_PLAYER_37'))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
