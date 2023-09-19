extends Node2D

signal dialog_finished
signal choice_answered(respond)
signal battle_started
signal battle_ended

@onready var loader = $/root/Loader

@onready var dialog_container = $UI/Dialog
@onready var dialog_name = $UI/Dialog/Wrapper/ProfileWrapper/Name
@onready var dialog_picture = $UI/Dialog/Wrapper/ProfileWrapper/Picture
@onready var dialog_content = $UI/Dialog/Wrapper/Text/Margin/Content
@onready var dialog_choices_container = $UI/Dialog/Wrapper/ProfileWrapper/Choices/Wrapper

@onready var information = $UI/Information

@onready var inventory_background = $UI/Inventory/Bg
@onready var inventory_container = $UI/Inventory/Margin/Grid

var is_in_dialog = false
var is_typing = false
var is_choice = false
var dialog_choices = []

func _ready():
	pass

func dialog(name, content, choices = []):
	dialog_container.show()
	information.hide()
	inventory_background.hide()
	inventory_container.hide()
	if (name != null):
		dialog_name.show()
		dialog_name.text = name
	else:
		dialog_name.hide()
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
				# information.show()
				emit_signal('dialog_finished')
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
