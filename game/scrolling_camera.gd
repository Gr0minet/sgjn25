class_name ScrollingCamera
extends Node2D


const SPEED: float = 20.0 # pixel/mouse_scroll


@onready var _camera_focus: Marker2D = $CameraFocus
@onready var _camera_2d: Camera2D = $CameraFocus/Camera2D

var _min_position: float = 0
var _max_position: float = 0


func _ready() -> void:
	State.update_height_reached.connect(_on_height_reached_updated)


func _process(delta: float) -> void:
	if State.current != State.Value.PLAYING:
		return


func _unhandled_input(event: InputEvent) -> void:
	if (
		event is InputEventMouseButton
		and (event as InputEventMouseButton).button_index == MOUSE_BUTTON_WHEEL_UP
	):
		_camera_focus.position.y -= SPEED
		_camera_focus.position.y = clampf(_camera_focus.position.y, _min_position, _max_position)
	elif (
		event is InputEventMouseButton
		and (event as InputEventMouseButton).button_index == MOUSE_BUTTON_WHEEL_DOWN
	):
		_camera_focus.position.y += SPEED
		_camera_focus.position.y = clampf(_camera_focus.position.y, _min_position, _max_position)


func set_min_position(value: float) -> void:
	_min_position = value


func _on_height_reached_updated(value: float) -> void:
	_min_position = -value
