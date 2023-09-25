extends Node2D

signal dialog_finished
signal player_move
signal player_dash
signal player_quick_cast

@onready var player = $/root/Loader/World/TileMap/Player
@onready var enemy = $/root/Loader/World/TileMap/Enemy
@onready var guide_container = $/root/Loader/World/UI/Guide
@onready var guide_label = $/root/Loader/World/UI/Guide/Wrapper/Text/Margin/Content
@onready var keys = $/root/Loader/World/UI/Keys
@onready var keys_animation = $/root/Loader/World/UI/Keys/Animation

var is_typing = false
var is_in_dialog = false
var movement_pressed = []

# Called when the node enters the scene tree for the first time.
func _ready():
	player.is_stunned = false
	enemy.is_stunned = false
	
	await show_guide('Selamat datang di arena pertarungan Jayasundara.')
	await show_guide('Gunakan tombol WASD untuk bergerak.')
	await player_move
	
	await show_guide('Gunakan tombol Enter untuk melakukan dash.')
	await player_dash
	
	keys_animation.play('enterance')
	await keys_animation.animation_finished
	keys_animation.play('blinking')
	await show_guide('Perhatikan tombol-tombol berikut. Tombol ini merupakan tombol-tombol yang digunakan untuk melakukan kombinasi serangan. Kamu bisa mengubah tombol-tombol ini di pengaturan.')
	keys.hide()
	
	await show_guide('Untuk melakukan jurus [Bola Api], tekan kombinasi tombol 1-2.')
	await player.casting
	
	await show_guide('Untuk mereset kombinasi, tekan tombol Shift.')
	
	await show_guide('Kamu juga dapat menggunakan serangan cepat, yaitu menggunakan jurus yang telah kamu atur sebelumnya tanpa kombinasi. Gunakan tombol Spasi untuk melakukan serangan cepat.')
	await player_quick_cast
	
	await show_guide('Sekarang, coba hindari serangan ini.')
	enemy.state = 'attacking'
	
	await get_tree().create_timer(5).timeout
	enemy.state = 'idle'

	enemy.state = 'attacking'
	await show_guide('Kamu juga dapat menangkis serangan dengan cara menembakkan serangan ke arah musuh di saat yang bersamaan.')
	await player.casting

	enemy.state = 'idle'
	await show_guide('Bagus. Kamu sudah mengetahui dasarnya. Sekarang, hancurkan boneka latihan itu.')
	enemy.hp = 100
	enemy.get_node('Label').text = 'HP: 100'
	enemy.get_node('Label').show()
	enemy.state = 'attacking'
	
	await enemy.killed
	await show_guide('Selamat, kamu sudah menguasai dasar kombat di arena Jayasundara!')
	get_parent().emit_signal('battle_ended')

func show_guide(content):
	guide_label.text = ''
	is_typing = true
	is_in_dialog = true
	
	guide_container.show()

	for letter in content.length():
		if (is_typing):
			guide_label.text += content[letter]
			await get_tree().create_timer(0.05).timeout
		else:
			guide_label.text = content
			break
			
	is_typing = false
	
	await dialog_finished
	
func _input(event):
	if ((event is InputEventMouseButton and event.pressed)):
		if (is_typing):
			is_typing = false
		else:
			if (is_in_dialog):
				guide_container.hide()
				# information.show()
				emit_signal('dialog_finished')

	if (event is InputEventKey):
		if (Input.is_key_pressed(KEY_W) or Input.is_key_pressed(KEY_A) or Input.is_key_pressed(KEY_S) or Input.is_key_pressed(KEY_D)):
			if (not event.keycode in movement_pressed):
				movement_pressed.append(event.keycode)
			
			if (movement_pressed.size() == 4):
				emit_signal('player_move')
				
		if (Input.is_key_pressed(KEY_ENTER)):
			emit_signal('player_dash')
			
		if (Input.is_key_pressed(KEY_SPACE)):
			emit_signal('player_quick_cast')

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
