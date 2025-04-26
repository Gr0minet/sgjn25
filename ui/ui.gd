class_name UI
extends Control


signal game_started()

enum State {MAIN_MENU, GAME_STARTED}

signal blueprint_clicked(moving_block_scene: PackedScene)

@onready var _money_label: Label = %MoneyLabel
@onready var _blueprint_container: VBoxContainer = %BlueprintContainer
@onready var _start_label: Label = %StartLabel

var _state: State = State.MAIN_MENU


func _ready() -> void:
	_money_label.hide()
	_blueprint_container.hide()
	_start_label.show()
	
	for blueprint: Blueprint in _blueprint_container.get_children():
		blueprint.clicked.connect(_on_blueprint_clicked)


func _gui_input(event: InputEvent) -> void:
	if _state != State.MAIN_MENU:
		return
	
	if (
		event is InputEventMouseButton
		and (event as InputEventMouseButton).button_index == MOUSE_BUTTON_LEFT
		and (event as InputEventMouseButton).pressed
	):
		_start_game()


func _start_game() -> void:
	_money_label.show()
	_blueprint_container.show()
	_start_label.hide()
	_state = State.GAME_STARTED
	game_started.emit()


func set_money_label(amount: int) -> void:
	_money_label.text = str(amount) + " €"


func _on_blueprint_clicked(moving_block_scene: PackedScene) -> void:
	blueprint_clicked.emit(moving_block_scene)
