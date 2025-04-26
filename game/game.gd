class_name Game
extends Node2D

signal income_received(amount: int)

enum PlayState {IDLE, PLACING_BLUEPRINT}

const BOAT_INCOME: int = 100 # euro
const BOAT_RESPAWN_TIME_MIN: float = 1.0 # seconds
const BOAT_RESPAWN_TIME_MAX: float = 1.0 # seconds
const BOAT_SPAWN_POSITION_FROM_SCREEN_BORDER: float = 50 # pixels

@onready var _boat_spawn_timer: Timer = $BoatSpawnTimer
@onready var _boat_left_limit: Marker2D = $BoatLeftLimit
@onready var _boat_right_limit: Marker2D = $BoatRightLimit
@onready var _blocks_builder: BlocksBuilder = $BlocksBuilder
@onready var _ui: UI = $UICanvasLayer/UI

var _boat_scene: PackedScene = preload("uid://cimhmw5jvbwbx")
var _left_boat_spawned: bool = false
var _right_boat_spawned: bool = false
var _play_state: PlayState = PlayState.IDLE
var _current_blueprint_price: int = 0

var ground_level := 0.0


func _ready() -> void:
	State.money = 0
	_ui.blueprint_clicked.connect(_on_blueprint_clicked)
	_blocks_builder.connect("block_placed", _on_block_placed)
	State.game_started.connect(_on_game_started)
	var ground: Block = $Ground
	ground_level = ground.get_height()


func _spawn_boat(spawn_x_position: float, direction: int) -> void:
	var boat: Boat = _boat_scene.instantiate()
	boat.position.y = _boat_left_limit.position.y
	boat.position.x = spawn_x_position
	boat.direction = direction
	boat.income = BOAT_INCOME
	
	if direction == 1:
		boat.x_limit = _boat_left_limit.position.x
	else:
		boat.x_limit = _boat_right_limit.position.x
		
	boat.docked.connect(_on_boat_docked)
	boat.leaved.connect(_on_boat_leaved)
	add_child(boat)


func _get_boat_respawn_time() -> float:
	return randf_range(
		BOAT_RESPAWN_TIME_MIN,
		BOAT_RESPAWN_TIME_MAX
	)


func _on_boat_spawn_timer_timeout() -> void:
	var direction: int
	var spawn_x_position: float
	
	if not _left_boat_spawned and not _right_boat_spawned:
		direction = 1 if randi() % 2 else -1
		_boat_spawn_timer.start(_get_boat_respawn_time())
	elif not _left_boat_spawned:
		direction = 1
	else:
		direction = -1
	
	if direction == 1:
		spawn_x_position = -BOAT_SPAWN_POSITION_FROM_SCREEN_BORDER
		_left_boat_spawned = true
	else:
		spawn_x_position = get_viewport_rect().end.x + BOAT_SPAWN_POSITION_FROM_SCREEN_BORDER
		_right_boat_spawned = true
	
	_spawn_boat(spawn_x_position, direction)


func _on_boat_docked(amount: int) -> void:
	State.money += amount
	income_received.emit(amount)


func _on_boat_leaved(direction: int) -> void:
	if direction == 1:
		_right_boat_spawned = false
	else:
		_left_boat_spawned = false
	_boat_spawn_timer.start(_get_boat_respawn_time())


func _on_blueprint_clicked(block_resource: BlockResource) -> void:
	if _play_state != PlayState.IDLE:
		return
	
	_play_state = PlayState.PLACING_BLUEPRINT
	var moving_block: MovingBlock = block_resource.moving_block_scene.instantiate()
	moving_block.block_resource = block_resource
	moving_block.canceled.connect(_on_moving_block_canceled)
	moving_block.place_block.connect(_blocks_builder.on_place_block)
	add_child(moving_block)


func _on_moving_block_canceled() -> void:
	_play_state = PlayState.IDLE

func _on_block_placed(price: int, block: Block) -> void:
	State.money -= price
	_play_state = PlayState.IDLE
	
	var block_height := absf(ground_level - block.get_height())
	if block_height > State.height_reached:
		State.set_height_reached(block_height)


func _on_game_started() -> void:
	_boat_spawn_timer.start(_get_boat_respawn_time())
