extends Area2D

@onready var player = $/root/World/TileMap/Player
@onready var animation = $Animation
@onready var trail = $Trail
@onready var explosion = $Explosion
@onready var is_visible = $IsVisible

var speed = 500
var sender
var direction

func _ready():
	add_to_group('destroyable_particle')
	
	set_physics_process(false)

func init(dir, send):
	direction = dir
	sender = send
	
	trail.emitting = true
	
	animation.play('default')
	
	set_physics_process(true)

func destroy(body):
	trail.emitting = false
	explosion.emitting = true
	set_physics_process(false)

	var tween = get_tree().create_tween()
	tween.tween_property(animation, 'scale', Vector2(0, 0), 0.2)

	if (is_visible.is_on_screen()):
		player.camera.shake_for(0.2)
		
	if (body.is_in_group('enemy')):
		body.attacked(10)
		
	await get_tree().create_timer(0.5).timeout
	
	queue_free()

func _physics_process(delta):
	position += direction * speed * delta

func _on_body_entered(body):
	if (body != sender):
		destroy(body)

func _on_area_entered(area):
	if (area.get_parent().is_in_group('destroyable_particle') and area.sender != sender):
		destroy(area)
		area.destroy(self)
