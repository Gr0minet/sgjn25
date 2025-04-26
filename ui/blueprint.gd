class_name Blueprint
extends VBoxContainer


signal clicked(block_resource: BlockResource)

@onready var _price_label: Label = $PriceLabel
@onready var _texture_rect: TextureRect = $TextureRect

var _block_resource: BlockResource

func _gui_input(event: InputEvent) -> void:
	if (
		event is InputEventMouseButton
		and (event as InputEventMouseButton).button_index == MOUSE_BUTTON_LEFT
		and (event as InputEventMouseButton).pressed
	):
		clicked.emit(_block_resource)


func set_block_resource(block_resource: BlockResource) -> void:
	_block_resource = block_resource
	_price_label.text = str(block_resource.price) + "€"
	_texture_rect.texture = block_resource.sprite
