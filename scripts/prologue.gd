extends Node2D

@onready var riani = $TileMap/Riani

# Called when the node enters the scene tree for the first time.
func _ready():
	riani.is_stunned = true
	
	riani.move_along_path([Vector2(32, 0), Vector2(64, 0)])

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
