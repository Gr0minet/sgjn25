extends PhysicsBody2D
class_name Block

@onready var shape: Shape2D = $CollisionShape2D.shape
@onready var sprite: Sprite2D = $Sprite2D

@export var color: Color = Color.BLACK
@export var is_static := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if !is_static:
		sprite.self_modulate = color

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
