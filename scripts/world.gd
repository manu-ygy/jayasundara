extends Node2D

signal dialog_finished
signal choice_answered(respond)
signal battle_started
signal battle_ended

@onready var loader = $/root/Loader

@onready var dialog_container = $UI/Dialog
@onready var dialog_name = $UI/Dialog/Wrapper/ProfileWrapper/Text/Margin/Wrapper/Name
@onready var dialog_picture = $UI/Dialog/Wrapper/ProfileWrapper/Picture
@onready var dialog_content = $UI/Dialog/Wrapper/ProfileWrapper/Text/Margin/Wrapper/Content
@onready var dialog_choices_container = $UI/Dialog/Wrapper/ProfileWrapper/Choices/Wrapper

@onready var information = $UI/Information

@onready var inventory_background = $UI/Inventory/Bg
@onready var inventory_container = $UI/Inventory/Margin/Grid

@onready var mission_container = $UI/Mission
@onready var mission_content = $UI/Mission/Margin/Wrapper/Content

var is_in_dialog = false
var is_typing = false
var is_choice = false
var is_mission_visible = false
var dialog_choices = []

var missions = {}

func _ready():
	pass

func update_mission(alias, text):
	missions[alias] = text
	render_mission()

func remove_mission(alias):
	missions.erase(alias)
	render_mission()

func render_mission():
	mission_content.text = ''
	for key in missions.keys():
		mission_content.text += missions[key] + '\n'

func dialog(name, content, avatar = null, choices = []):
	is_mission_visible = mission_container.visible
	dialog_container.show()
	information.hide()
	mission_container.hide()
	inventory_background.hide()
	inventory_container.hide()
	if (name != null):
		dialog_name.show()
		dialog_name.text = name
	else:
		dialog_name.hide()
		
	if (avatar != null):
		dialog_picture.show()
		dialog_picture.texture = load('res://assets/potrait/' + avatar.to_lower() + '.png')
	else:
		dialog_picture.hide()
	
	is_choice = choices.size() > 0
	is_in_dialog = true
	
	dialog_content.text = ''
	is_typing = true
	for letter in content.length():
		if (is_typing):
			dialog_content.text += content[letter]
			await get_tree().create_timer(0.05).timeout
		else:
			dialog_content.text = content
			break
			
	is_typing = false
	
	if (is_choice):
		choices = choices
		
		for child in dialog_choices_container.get_children():
			child.queue_free()
			
		var choice_count = 0
		for choice in choices:
			choice_count += 1
			var choice_button = Button.new()
			choice_button.text = choice.keys()[0]
			choice_button.pressed.connect(submit_choice.bind(choice.values()[0]))
			dialog_choices_container.add_child(choice_button)
		
		dialog_choices_container.show()
	
	if (is_choice):
		return await choice_answered
	else:
		await dialog_finished 
	
func submit_choice(value):
	dialog_choices_container.hide()
	dialog_container.hide()
	emit_signal('choice_answered', value)
	
func start_battle(name, enemy):
	loader.start_battle(name, enemy)
	loader.battle_ended.connect(emit_signal.bind('battle_ended'))
	
func add_inventory():
	pass
	
func start_tutorial():
	loader.start_tutorial()
	loader.battle_ended.connect(emit_signal.bind('battle_ended'))
	
func _input(event):
	if ((event is InputEventMouseButton and event.pressed) or Input.is_key_pressed(KEY_ENTER) or Input.is_key_pressed(KEY_SPACE)):
		if (is_typing):
			is_typing = false
		else:
			if (!is_choice and is_in_dialog):
				is_in_dialog = false
				dialog_container.hide()
				inventory_container.show()
				inventory_background.show()
				mission_container.visible = is_mission_visible
				# information.show()
				emit_signal('dialog_finished')
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_farmer_visibility_changed():
	pass # Replace with function body.
