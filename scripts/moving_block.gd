extends Area2D
class_name MovingBlock


signal canceled()

@export var color_neutral: Color = Color.WHITE
@export var color_invalid: Color
@export var color_valid: Color

@onready var inside_area: Area2D = $InsideArea

var opacity: float
var is_connected := false
var is_overlapping := false


func _process(delta: float) -> void:
	var cursor_position := get_viewport().get_camera_2d().get_global_mouse_position()
	global_position = cursor_position
	opacity = modulate.a
	color_neutral = Color(color_neutral, opacity)
	color_invalid = Color(color_invalid, opacity)
	color_valid = Color(color_valid, opacity)
	
	is_connected = has_overlapping_areas()
	is_overlapping = inside_area.has_overlapping_bodies()
	
	if is_overlapping:
		modulate = color_invalid
	elif is_connected:
		modulate = color_valid
	else:
		modulate = color_neutral


func _input(event: InputEvent) -> void:
	if (
		event is InputEventMouseButton
		and (event as InputEventMouseButton).button_index == MOUSE_BUTTON_RIGHT
		and (event as InputEventMouseButton).pressed
	):
		canceled.emit()
		queue_free()
