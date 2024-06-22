extends CharacterBody2D

signal arrived_at_path
signal interacted_with_player

@onready var information = $/root/Loader/World/UI/Information
@onready var player = $/root/Loader/World/TileMap/Player
@onready var animation = $AnimationTree
@onready var state_machine = $AnimationTree.get('parameters/playback')
@onready var interaction = $Interaction
@onready var leader = player
@onready var collision = $Collision
@onready var interaction_area = $InteractionArea
@onready var following_timer = get_node_or_null('FollowingTimer')

var player_inside = false
var is_in_dialog = false

@export var movement_speed = 100

var current_path = []
var path_index = 0
var current_point = Vector2.ZERO

@export var is_following_leader = false: set = toggle_following_leader
var leader_positions = []

func _ready():	
	state_machine.travel('idle')
	render_visibility()

func _physics_process(delta):
	if (!is_following_leader):
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
		else:
			state_machine.travel('idle')
			velocity = Vector2.ZERO
	else:
		if (leader_positions.size() != 0):
			var direction = global_position.direction_to(leader_positions[0])
			velocity = direction * movement_speed
			
			animation.set('parameters/walk/blend_position', direction)
			animation.set('parameters/idle/blend_position', direction)
			
			state_machine.travel('walk')
			
			if (global_position.distance_to(leader_positions[0]) < 3 or global_position.distance_to(leader.global_position) <= 32):
				leader_positions.remove_at(0)
		else:
			velocity = Vector2.ZERO
			state_machine.travel('idle')

	if (global_position.y > player.global_position.y):
		$Sprite.z_index = 1000
	else:
		$Sprite.z_index = 0

	move_and_slide()

func move_along_path(path):
	current_path = path
	current_point = path[0]
	path_index = 0
	
	await arrived_at_path
	
func clear_path():
	current_path = []
	current_point = null
	path_index = 0
	
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
		emit_signal('interacted_with_player')
		await interaction.interact()
		is_in_dialog = false
		player.is_stunned = false

func _on_interaction_area_body_entered(body):
	if (body == player):
		player_inside = true
		information.text = 'Tekan E untuk interaksi.'
		information.show()

func _on_interaction_area_body_exited(body):
	if (body == player):
		player_inside = false
		information.hide()

func _on_following_timer_timeout():
	if (global_position.distance_to(leader.global_position) > 32):
		leader_positions.append(leader.global_position)
		
func toggle_following_leader(value):
	is_following_leader = value
	
	if (is_following_leader):
		following_timer.start()
	else:
		following_timer.stop()

func _on_visibility_changed():
	render_visibility()

func render_visibility():
	if (visible):
		get_node('Collision').disabled = false
		get_node('InteractionArea').monitoring = true
	else:
		get_node('Collision').disabled = true
		get_node('InteractionArea').monitoring = false
