extends PhysicsBody2D
class_name Block

@onready var shape: Shape2D = $CollisionShape2D.shape
@onready var sprite: Sprite2D = $Sprite2D

@export var color: Color = Color.BLACK
@export var is_static := false

func get_height() -> float:
	if is_static: return global_position.y
	var size = sprite.texture.get_size() * sprite.scale
	return global_position.y - size.y / 2.0
