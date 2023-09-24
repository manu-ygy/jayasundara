extends CharacterBody2D

@onready var player = $/root/Loader/World/TileMap/Player
@onready var animation = $Animation
@onready var outline_circle = $OutlineCircle
@onready var lifetime_timer = $LifetimeTimer
@onready var attack_timer = $AttackTimer
@onready var thunder = $Thunder

var speed = 250
var sender
var direction
var is_initiated = false
var allow_attacking = false

var acceleration = Vector2.ZERO

var is_destroyed = false
var targets = []

var hp = 100

func _ready():
	set_physics_process(false)

func init(dir, send):
	direction = dir
	sender = send
	
	if (sender != player):
		outline_circle.texture = load('res://assets/npc/outline-red.png')
	
	set_physics_process(true)
	
	animation.play('enterance')
	await animation.animation_finished
	animation.play('loop')
	
	outline_circle.show()
	is_initiated = true
	speed = 150
	
	lifetime_timer.start()
	
func _physics_process(delta):
	if (is_initiated):
		velocity = Vector2.ZERO
		if (targets.size() > 0):
			if (!is_destroyed):
				if (global_position.distance_to(targets[0].global_position) > 64):
					velocity = global_position.direction_to(targets[0].global_position) * speed
					thunder.points[1] = Vector2.ZERO
				else:
					if (allow_attacking):
						thunder.points[1] = to_local(targets[0].global_position)
						targets[0].attacked(0.5)
					else:
						thunder.points[1] = Vector2.ZERO
			else:
				velocity = global_position.direction_to(targets[0].global_position) * speed
			
				thunder.points[1] = Vector2.ZERO
				if (global_position.distance_to(targets[0].global_position) < 8):
					targets[0].attacked(20)
					queue_free()
		else:
			if (global_position.distance_to(sender.global_position) > 32):
				velocity = global_position.direction_to(sender.global_position) * speed
				
			if (is_destroyed):
				queue_free()
		
		if (velocity != Vector2.ZERO):
			animation.flip_h = velocity.x < 0
		
		move_and_slide()
	else:
		position += direction * speed * delta

func destroy(body):
	is_destroyed = true
	
	var tween = get_tree().create_tween()
	tween.tween_property(animation, 'scale', Vector2(0, 0), 0.2)
		
	if (body.is_in_group('enemy')):
		body.attacked(10)
	
	queue_free()
	
func attacked(damage):
	# damage is aborted
	hp -= damage
	if (hp < 0):
		$Label.text = str(hp)
		is_destroyed = true
		speed = 250

func _on_attack_radius_body_entered(body):
	if ((body is CharacterBody2D or body.is_in_group('enemy')) and body != sender):
		targets.append(body)

func _on_attack_radius_body_exited(body):
	if (body in targets):
		targets.erase(body)

func _on_hit_box_area_entered(area):
	if (area.is_in_group('destroyable_particle') and area.sender != sender and !is_destroyed):
		area.destroy(self)

func _on_lifetime_timer_timeout():
	is_destroyed = true
	speed = 250

func _on_attack_timer_timeout():
	allow_attacking = true
	
	await get_tree().create_timer(0.5).timeout
	
	allow_attacking = false
