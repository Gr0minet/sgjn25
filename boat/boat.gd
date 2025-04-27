class_name Boat
extends Node2D


enum Side {RIGHT, LEFT}

signal docked(pirate: bool, income: int)
signal leaved(side: Side)

enum BoatState {ARRIVING, LEAVING, IDLE}

const PIRATE_COLOR: Color = Color.BLACK
const OFF_SCREEN_MARGIN: float = 140.0
const PIRATE_SPRITE: Texture2D = preload("uid://b1j855d1pv3fp")
const IDLE_TIME: float = 1.0 # second
const PIRATE_SPEED: float = 100.0 # pixel/second
const NORMAL_SPEED: float = 300.0 # pixel/second
const PIRATE_MALUS: int = 300 # euro

@onready var _sprite_2d: Sprite2D = $Sprite2D
@onready var _idle_timer: Timer = $IdleTimer
@onready var _income_label: Label = $IncomeLabel
@onready var _animation_player: AnimationPlayer = $AnimationPlayer
@onready var _click_detector: Area2D = $ClickDetector

var direction: int
var x_limit: float
var income: int
var pirate: bool
var side: Boat.Side

var _state: BoatState = BoatState.ARRIVING


func _ready() -> void:
	if pirate:
		_sprite_2d.texture = PIRATE_SPRITE
		modulate = PIRATE_COLOR
	if direction == 1:
		_sprite_2d.flip_h = true
	_income_label.hide()
	_state = BoatState.ARRIVING


func _physics_process(delta: float) -> void:
	if _state == BoatState.IDLE:
		return
		
	var speed: float = PIRATE_SPEED if pirate else NORMAL_SPEED
	position.x += speed * delta * direction

	var sprite_width: float = _sprite_2d.texture.get_width() * _sprite_2d.scale.x
	if _state == BoatState.LEAVING:
		if (
			direction == 1 and position.x + sprite_width/2 > get_viewport_rect().end.x + OFF_SCREEN_MARGIN
			or direction == -1 and position.x - sprite_width/2 < -OFF_SCREEN_MARGIN
		):
			leaved.emit(side)
			queue_free()
			set_physics_process(false)
	
	if _state == BoatState.ARRIVING:
		if (
			direction == 1 and position.x + sprite_width/2 > x_limit
			or direction == -1 and position.x - sprite_width/2 < x_limit
		):
			_dock()


func _on_idle_timer_timeout() -> void:
	if direction == 1:
		direction = -1
		_sprite_2d.flip_h = false
	else:
		direction = 1
		_sprite_2d.flip_h = true
	_state = BoatState.LEAVING


func _dock() -> void:
	if pirate:
		docked.emit(pirate, PIRATE_MALUS)
	else:
		_income_label.text = str(income) + " €"
		_animation_player.play("get_income")
		docked.emit(pirate, income)
	
	_state = BoatState.IDLE
	_idle_timer.start(IDLE_TIME)


func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if (
		event is InputEventMouseButton
		and (event as InputEventMouseButton).button_index == MOUSE_BUTTON_LEFT
		and (event as InputEventMouseButton).pressed
	):
		State.ship_sinked.emit()
		set_physics_process(false)
		_click_detector.input_pickable = false
		_animation_player.play("die")
		await _animation_player.animation_finished
		leaved.emit(side)
		queue_free()
