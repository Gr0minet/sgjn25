class_name Blueprint
extends VBoxContainer


signal clicked(block_resource: BlockResource)

@onready var _price_label: Label = $PriceLabel
@onready var _texture_rect: TextureRect = $TextureRect

var _block_resource: BlockResource
var _clickable: bool = false

func _ready() -> void:
	if State.money < _block_resource.price:
		set_clickable(false)
	elif not _clickable:
		set_clickable(true)
	State.money_changed.connect(_on_money_changed)


func _gui_input(event: InputEvent) -> void:
	if (
		event is InputEventMouseButton
		and (event as InputEventMouseButton).button_index == MOUSE_BUTTON_LEFT
		and (event as InputEventMouseButton).pressed
		and _clickable
	):
		clicked.emit(_block_resource)


func set_block_resource(block_resource: BlockResource) -> void:
	_block_resource = block_resource
	if not is_node_ready():
		await ready
	_price_label.text = str(block_resource.price) + "€"
	_texture_rect.texture = block_resource.sprite


func _on_money_changed(new_value: int) -> void:
	if new_value < _block_resource.price:
		set_clickable(false)
	elif not _clickable:
		set_clickable(true)


func set_clickable(value: bool) -> void:
	_clickable = value
	if _clickable:
		modulate = Color.WHITE
	else:
		modulate = Color.WEB_GRAY
