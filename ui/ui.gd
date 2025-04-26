class_name UI
extends Control


signal blueprint_clicked(moving_block_scene: PackedScene)

@onready var _money_label: Label = $MarginContainer/MoneyLabel
@onready var _blueprint_container: VBoxContainer = $BlueprintContainer


func _ready() -> void:
	for blueprint: Blueprint in _blueprint_container.get_children():
		blueprint.clicked.connect(_on_blueprint_clicked)


func set_money_label(amount: int) -> void:
	_money_label.text = str(amount) + " €"


func _on_blueprint_clicked(moving_block_scene: PackedScene) -> void:
	blueprint_clicked.emit(moving_block_scene)
