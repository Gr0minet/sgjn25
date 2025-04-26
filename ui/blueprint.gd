class_name Blueprint
extends VBoxContainer


signal clicked(moving_block_scene: PackedScene)

@export var moving_block_scene: PackedScene = preload("uid://5011xni60ds6")


func _gui_input(event: InputEvent) -> void:
	if (
		event is InputEventMouseButton
		and (event as InputEventMouseButton).button_index == MOUSE_BUTTON_LEFT
		and (event as InputEventMouseButton).pressed
	):
		clicked.emit(moving_block_scene)
