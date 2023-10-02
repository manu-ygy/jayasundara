extends Node

@onready var npc = get_parent()
@onready var ui = $/root/Loader/World

# Called every frame. 'delta' is the elapsed time since the previous frame.
func interact():
	pass
	# var do_sparring = await ui.dialog('Om-om', 'Mau sparring?', [{'Boleh': 'accept'}, {'Nggak dulu': 'reject'}, {'Riil kah min?': 'real'}])

#	if (do_sparring == 'accept'):
#		ui.start_battle('Riani', 'Om-om')
#		await ui.battle_ended
#
#		await ui.dialog('Om-om', 'GG juga ...')
#	elif (do_sparring == 'reject'):
#		await ui.dialog('Om-om', 'Yahaha takut :P')
#	else:
#		await ui.dialog('Om-om', 'Rill dek.')
