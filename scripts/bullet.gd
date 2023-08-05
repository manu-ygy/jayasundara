extends Area2D

@onready var player = $/root/World/Player
@onready var animation = $AnimatedSprite2D
@onready var trail = $Trail
@onready var explosion = $Explosion

var speed = 500

func _ready():
	animation.play('default')
	trail.emitting = true

func _physics_process(delta):
	position += transform.x * speed * delta

func _on_body_entered(body):
	if (body != player):
		trail.emitting = false
		explosion.emitting = true
		set_physics_process(false)

		var tween = get_tree().create_tween()
		tween.tween_property(animation, 'scale', Vector2(0, 0), 0.2)

		if (global_position.distance_to(player.global_position) < 128):
			player.camera.shake_for(0.2)
			
		await get_tree().create_timer(0.5).timeout
		
		queue_free()
