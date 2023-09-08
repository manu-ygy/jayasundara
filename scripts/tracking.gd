extends Area2D

@onready var player = $/root/Loader/World/TileMap/Player
@onready var animation = $Animation
@onready var trail = $Trail

var speed = 450
var sender
var direction
var steer_force = 75

var velocity = Vector2.ZERO
var acceleration = Vector2.ZERO

var is_destroyed = false
var target

func _ready():
	add_to_group('destroyable_particle')
	
	set_physics_process(false)

func init(dir, send, trgt):
	target = trgt
	direction = dir
	sender = send
	
	trail.emitting = true
	
	set_physics_process(true)
	
func seek():
	var steer = Vector2.ZERO
	if target:
		var desired = (target.position - position).normalized() * speed
		steer = (desired - velocity).normalized() * steer_force
	return steer

func _physics_process(delta):
	acceleration += seek()
	velocity += acceleration * delta
	velocity = velocity.clamp(Vector2(speed, speed) * -1, Vector2(speed, speed))
	rotation = velocity.angle()
	position += velocity * delta

func destroy(body):
	is_destroyed = true
	
	trail.emitting = false
	
	var tween = get_tree().create_tween()
	tween.tween_property(animation, 'scale', Vector2(0, 0), 0.2)
		
	if (body.is_in_group('enemy')):
		body.attacked(10)
	
	queue_free()

func _on_body_entered(body):
	if (body == target): 
		destroy(body)
