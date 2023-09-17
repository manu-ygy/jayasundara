extends CharacterBody2D

signal arrived_at_path

@onready var information = $/root/Loader/World/UI/Information
@onready var player = $/root/Loader/World/TileMap/Player
@onready var animation = $AnimationTree
@onready var state_machine = $AnimationTree.get('parameters/playback')
@onready var interaction = $Interaction

var player_inside = false
var is_in_dialog = false

@export var movement_speed = 100

var current_path = []
var path_index = 0
var current_point = Vector2.ZERO

func _physics_process(delta):
	if (current_path.size() != 0):
		if (global_position.distance_to(current_path[path_index]) > 2):
			var direction = global_position.direction_to(current_path[path_index])
			velocity = direction * movement_speed
			
			animation.set('parameters/walk/blend_position', direction)
			animation.set('parameters/idle/blend_position', direction)
			
			state_machine.travel('walk')
		else:
			velocity = Vector2.ZERO
			if (current_path.size() -1 > path_index):
				path_index += 1
			else:
				current_path = []
				emit_signal('arrived_at_path')
				state_machine.travel('idle')
				
		move_and_slide()

func move_along_path(path):
	current_path = path
	current_point = path[0]
	path_index = 0
	
	await arrived_at_path
	
func align(direction):
	animation.set('parameters/walk/blend_position', direction)
	animation.set('parameters/idle/blend_position', direction)
	
func move(x_or_vector, y = null):
	if (y == null):
		global_position = x_or_vector
	else:
		global_position = Vector2(x_or_vector, y)

func _input(event):
	if (Input.is_action_just_released('interact') and player_inside and !is_in_dialog):
		is_in_dialog = true
		player.is_stunned = true
		await interaction.interact()
		is_in_dialog = false
		player.is_stunned = false

func _on_interaction_area_body_entered(body):
	if (body == player):
		player_inside = true
		information.show()

func _on_interaction_area_body_exited(body):
	if (body == player):
		player_inside = false
		information.hide()
