extends Area2D

@onready var player = $/root/Loader/World/TileMap/Player
@onready var animation = $Animation
@onready var raycast = $RayCast2D
@onready var collision = $Collision
@onready var explosion = $Explosion

var direction
var sender

func _ready():
	pass
	
func init(dir, send):
	direction = dir
	sender = send
	
	for x in range(5):
		var pillar_pos = direction * 32 * x + (Vector2(32, 32) * direction)
		raycast.target_position = pillar_pos + Vector2(32, 32) * direction
		
		if (!raycast.is_colliding()):
			explosion.position = pillar_pos - Vector2(0, -12)
			explosion.emitting = true
			
			var pillar = AnimatedSprite2D.new()
			pillar.sprite_frames = animation.sprite_frames
			pillar.flip_h = direction.x <= 0
			pillar.position = pillar_pos
			pillar.play('default')
			pillar.connect('animation_finished', pillar.queue_free)
			
			var pillar_col = CollisionShape2D.new()
			pillar_col.shape = collision.shape
			pillar_col.position = pillar_pos
			
			player.camera.shake_for(0.002 * pillar.global_position.distance_to(player.global_position))
			
			add_child(pillar)
			add_child(pillar_col)
		
		await get_tree().create_timer(0.3).timeout
		explosion.emitting = false
		
	await get_tree().create_timer(0.5).timeout
	queue_free()

func _on_body_entered(body):
	if (body.is_in_group('enemy')):
		body.attacked(5)

func _on_area_entered(area):
	if (area.is_in_group('destroyable_particle') and area.sender != sender):
		area.destroy(self)
