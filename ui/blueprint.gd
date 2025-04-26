@tool
class_name Blueprint
extends VBoxContainer


signal clicked(moving_block_scene: PackedScene)

@export var moving_block_scene: PackedScene = preload("uid://5011xni60ds6")
@export var price: int = 100: # euro
	set(value):
		if not is_node_ready():
			await ready
		price = value
		_label.text = str(price) + "€"	

@onready var _label: Label = $Label


func _gui_input(event: InputEvent) -> void:
	if (
		event is InputEventMouseButton
		and (event as InputEventMouseButton).button_index == MOUSE_BUTTON_LEFT
		and (event as InputEventMouseButton).pressed
	):
		clicked.emit(moving_block_scene)
