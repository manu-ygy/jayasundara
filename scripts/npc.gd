extends CharacterBody2D

@onready var ui = $/root/Loader/World
@onready var information = $/root/Loader/World/UI/Information
@onready var player = $/root/Loader/World/TileMap/Player
@onready var animation = $Animation

var player_inside = false
var is_in_dialog = false

func _ready():
	animation.play('default')

func _input(event):
	if (Input.is_action_just_released('interact') and player_inside and !is_in_dialog):
		is_in_dialog = true
		
		await ui.dialog('Om-om', 'Halo deck.')
		var do_sparring = await ui.dialog('Om-om', 'Mau sparring?', [{'Boleh': 'accept'}, {'Nggak dulu': 'reject'}, {'Riil kah min?': 'real'}])

		if (do_sparring == 'accept'):
			ui.start_battle()
			await ui.battle_ended
			
			await ui.dialog('Om-om', 'GG juga ...')
		elif (do_sparring == 'reject'):
			await ui.dialog('Om-om', 'Yahaha takut :P')
		else:
			await ui.dialog('Om-om', 'Rill dek.')

		is_in_dialog = false

func _on_interaction_area_body_entered(body):
	if (body == player):
		player_inside = true
		information.show()

func _on_interaction_area_body_exited(body):
	if (body == player):
		player_inside = false
		information.hide()
