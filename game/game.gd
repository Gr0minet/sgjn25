class_name Game
extends Node2D

signal income_received(amount: int)

enum State {IDLE, PLACING_BLUEPRINT}

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
var _money: int = 0
var _state: State = State.IDLE


func _ready() -> void:
	_money = 0
	_boat_spawn_timer.start(_get_boat_respawn_time())
	_ui.blueprint_clicked.connect(_on_blueprint_clicked)
	_blocks_builder.connect("block_placed", _on_block_placed)


func _spawn_boat(x_spawn_position: float, direction: int) -> void:
	var boat: Boat = _boat_scene.instantiate()
	boat.position.y = _boat_left_limit.position.y
	boat.position.x = x_spawn_position
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
	var x_spawn_position: float
	
	if not _left_boat_spawned and not _right_boat_spawned:
		direction = 1 if randi() % 2 else -1
		_boat_spawn_timer.start(_get_boat_respawn_time())
	elif not _left_boat_spawned:
		direction = 1
	else:
		direction = -1
	
	if direction == 1:
		x_spawn_position = -BOAT_SPAWN_POSITION_FROM_SCREEN_BORDER
		_left_boat_spawned = true
	else:
		x_spawn_position = get_viewport_rect().end.x + BOAT_SPAWN_POSITION_FROM_SCREEN_BORDER
		_right_boat_spawned = true
	
	_spawn_boat(x_spawn_position, direction)


func _on_boat_docked(amount: int) -> void:
	_money += amount
	income_received.emit(amount)
	_ui.set_money_label(_money)


func _on_boat_leaved(direction: int) -> void:
	if direction == 1:
		_right_boat_spawned = false
	else:
		_left_boat_spawned = false
	_boat_spawn_timer.start(_get_boat_respawn_time())


func _on_blueprint_clicked(moving_block_scene: PackedScene) -> void:
	if _state != State.IDLE:
		return
	
	_state = State.PLACING_BLUEPRINT
	var moving_block: MovingBlock = moving_block_scene.instantiate()
	moving_block.canceled.connect(_on_moving_block_canceled)
	moving_block.place_block.connect(_blocks_builder.on_place_block)
	add_child(moving_block)


func _on_moving_block_canceled() -> void:
	_state = State.IDLE

func _on_block_placed(_block: Block) -> void:
	_state = State.IDLE
