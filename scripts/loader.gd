extends Node2D

@onready var transition = $UI/Transition
@onready var animation = $UI/Animation

@onready var world = load('res://scenes/world.tscn').instantiate()
var arena_instance = load('res://scenes/arena.tscn')

signal battle_ended

var arena

func _ready():
	transition.show()
	animation.play('transition')
	await animation.animation_finished
	
	world.connect('battle_started', start_battle)
	add_child(world)
	
	await get_tree().process_frame
	
	animation.play_backwards('transition')
	await animation.animation_finished
	transition.hide()
	
func start_battle(player_name, enemy_name):
	transition.show()
	animation.play('transition')
	await animation.animation_finished
	
	arena = arena_instance.instantiate()
	arena.connect('battle_ended', end_battle)
	
	call_deferred('remove_child', world)
	call_deferred('add_child', arena)
	
	await get_tree().process_frame 
	
	arena.initiate_battle(player_name, enemy_name)
	
	animation.play_backwards('transition')
	await animation.animation_finished
	transition.hide()
	
	# pause(world, false)
func end_battle():
	transition.show()
	animation.play('transition')
	await animation.animation_finished
	
	call_deferred('add_child', world)
	call_deferred('remove_child', arena)
	
	await get_tree().process_frame
	
	animation.play_backwards('transition')
	await animation.animation_finished
	transition.hide()
	
	emit_signal('battle_ended')
