class_name ScrollingCamera
extends Node2D


const SCROLL_TRIGGER_MARGIN: float = 100.0
const SPEED: float = 300.0 # pixel/second

@onready var _camera_focus: Marker2D = $CameraFocus
@onready var _camera_2d: Camera2D = $CameraFocus/Camera2D

var _min_position: float = -INF
var _max_position: float = 0


func _process(delta: float) -> void:
	var direction: int = 0
	
	var mouse_position: Vector2 = get_viewport().get_mouse_position()
	if mouse_position.y < SCROLL_TRIGGER_MARGIN:
		direction = -1
	elif mouse_position.y > get_viewport_rect().end.y - SCROLL_TRIGGER_MARGIN:
		direction = 1
	else:
		return
	
	_camera_focus.position.y += SPEED * delta * direction
	_camera_focus.position.y = clampf(_camera_focus.position.y, _min_position, _max_position)
	

func set_min_position(value: float) -> void:
	_min_position = value
