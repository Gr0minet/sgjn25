class_name UI
extends Control


signal blueprint_clicked(block_resource: BlockResource)

const BLOCK_RESOURCE_FOLDER: String = "res://block/"
const BLUEPRINT_SCENE: PackedScene = preload("uid://bi7q5vvl3qlba")

@onready var _money_label: Label = %MoneyLabel
@onready var _blueprint_container: VBoxContainer = %BlueprintContainer
@onready var _blueprint_container_2: VBoxContainer = %BlueprintContainer2
@onready var _start_label: Label = %StartLabel
@onready var _animation_player: AnimationPlayer = $AnimationPlayer
@onready var _money_malus: Label = %MoneyMalus
@onready var _warning_left: TextureRect = %WarningLeft
@onready var _warning_right: TextureRect = %WarningRight
@onready var _warning_left_animation_player: AnimationPlayer = %WarningLeftAnimationPlayer
@onready var _warning_right_animation_player: AnimationPlayer = %WarningRightAnimationPlayer

var _block_resource_list: Array = []


func _ready() -> void:
	_money_label.hide()
	_blueprint_container.hide()
	_blueprint_container_2.hide()
	_start_label.show()
	_warning_left.hide()
	_warning_right.hide()
	
	State.money_changed.connect(_on_money_changed)
	State.update_age.connect(_update_age)
	State.pirated.connect(_on_pirated)
	State.pirate_spawned.connect(_on_pirate_spawned)
	
	_setup_block_resource_list()
	_update_age(State.age)



func _gui_input(event: InputEvent) -> void:
	if State.current != State.Value.MAIN_MENU:
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
	_blueprint_container_2.show()
	_start_label.hide()
	State.start_game()


func _on_money_changed(new_value: int) -> void:
	set_money_label(new_value)


func set_money_label(amount: int) -> void:
	_money_label.text = str(amount) + " €"


func _on_blueprint_clicked(block_resource: BlockResource) -> void:
	blueprint_clicked.emit(block_resource)


func _setup_block_resource_list() -> void:
	var block_resource_folder: DirAccess = DirAccess.open(BLOCK_RESOURCE_FOLDER)
	for directory_name: String in block_resource_folder.get_directories():
		var age_block_list: Array[BlockResource] = []
		var base_path: String = BLOCK_RESOURCE_FOLDER + "/" + directory_name
		var age_folder: DirAccess = DirAccess.open(base_path)
		for block_resource_file: String in age_folder.get_files():
			if '.tres.remap' in block_resource_file:
				block_resource_file = block_resource_file.trim_suffix('.remap')
			var block_resource: BlockResource = ResourceLoader.load(base_path + "/" + block_resource_file)
			age_block_list.append(block_resource)
		_block_resource_list.append(age_block_list)


func _add_blueprint_to(container: VBoxContainer, block_resource: BlockResource) -> void:
	var blueprint: Blueprint = BLUEPRINT_SCENE.instantiate()
	blueprint.clicked.connect(_on_blueprint_clicked)
	blueprint.set_block_resource(block_resource)
	container.add_child(blueprint)


func _update_age(age: int) -> void:
	if age >= _block_resource_list.size():
		return
	
	for child: Node in _blueprint_container.get_children():
		child.queue_free()
	for child: Node in _blueprint_container_2.get_children():
		child.queue_free()
	
	for block_resource: BlockResource in _block_resource_list[age].slice(0, _block_resource_list[0].size()/2):
		_add_blueprint_to(_blueprint_container, block_resource)
	for block_resource: BlockResource in _block_resource_list[age].slice(_block_resource_list[0].size()/2):
		_add_blueprint_to(_blueprint_container_2, block_resource)


func _on_pirated(amount: int) -> void:
	_money_malus.text = "-" + str(amount)
	_animation_player.play("pirated")


func _on_pirate_spawned(side: Boat.Side) -> void:
	if side == Boat.Side.LEFT:
		_warning_left_animation_player.play("warning_left")
	else:
		_warning_right_animation_player.play("warning_right")
