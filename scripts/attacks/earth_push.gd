extends Area2D

@onready var player = $/root/Loader/World/TileMap/Player
@onready var animation = $Animation
@onready var raycast = $RayCast2D
@onready var collision = $Collision
@onready var explosion = $Explosion

var direction
var sender

func _ready():
	set_physics_process(false)
	
func init(dir, send):
	direction = dir
	sender = send

	var pillar_pos = direction * 32 + (Vector2(32, 32) * direction)
	raycast.target_position = pillar_pos + Vector2(32, 32) * direction

	if (!raycast.is_colliding() or raycast.get_collider().is_in_group('enemy')):
		explosion.position = pillar_pos - Vector2(0, -12)
		explosion.emitting = true
		
		var pillar = AnimatedSprite2D.new()
		pillar.sprite_frames = animation.sprite_frames
		pillar.flip_h = direction.x <= 0
		pillar.position = pillar_pos
		pillar.play('enterance')
		
		var pillar_col = CollisionShape2D.new()
		pillar_col.shape = collision.shape
		pillar_col.position = pillar_pos
		
		add_child(pillar)
		add_child(pillar_col)
		
		await get_tree().create_timer(0.3).timeout
		explosion.emitting = false
		
		set_physics_process(true)
	
func _physics_process(delta):
	global_position += direction

func _on_body_entered(body):
	if (body.is_in_group('enemy')):
		body.attacked(5)
	elif (body != sender):
		queue_free()

func _on_area_entered(area):
	if (area.is_in_group('destroyable_particle') and area.sender != sender):
		area.destroy(self)
