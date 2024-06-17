extends Sprite2D

@onready var silhouette = $Silhouette

func _ready():
	silhouette.texture = texture
	silhouette.offset = offset
	silhouette.flip_h = flip_h
	silhouette.hframes = hframes
	silhouette.vframes = vframes
	silhouette.frame = frame
	
func _set(property, value):
	if (is_instance_valid(silhouette)):
		match property:
			'texture':
				silhouette.texture = value
			'offset':
				silhouette.offset = value
			'flip_h':
				silhouette.flip_h = flip_h
			'hframes':
				silhouette.hframes = hframes
			'vframes':
				silhouette.vframes = vframes
			'frame':
				silhouette.frame = frame
