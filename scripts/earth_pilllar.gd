extends Node2D

@onready var animation = $Animation
@onready var raycast = $RayCast2D

func _ready():
	pass
	
func init(direction):
	for x in range(5):
		var pillar = AnimatedSprite2D.new()
		pillar.sprite_frames = animation.sprite_frames

		var pillar_pos = direction * 32 * x + (Vector2(32, 32) * direction)
		if (pillar_pos == Vector2.ZERO || pillar_pos.distance_to(raycast.get_collision_point()) > 32):
			pillar.position = pillar_pos
			print(pillar_pos.distance_to(raycast.get_collision_point()))

			pillar.play('default')
			pillar.connect('animation_finished', pillar.queue_free)
			raycast.rotation = direction.angle()
			add_child(pillar)
			await get_tree().create_timer(0.3).timeout
