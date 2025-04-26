class_name Boat
extends Node2D

signal docked(income: int)
signal leaved(direction: int)

enum BoatState {ARRIVING, LEAVING, IDLE}

const IDLE_TIME: float = 2.0 # second
const SPEED: float = 300.0 # pixel/second

@onready var _sprite_2d: Sprite2D = $Sprite2D
@onready var _idle_timer: Timer = $IdleTimer
@onready var _visible_on_screen_notifier_2d: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D
@onready var _income_label: Label = $IncomeLabel
@onready var _animation_player: AnimationPlayer = $AnimationPlayer

var direction: int
var x_limit: float
var income: int

var _state: BoatState = BoatState.ARRIVING


func _ready() -> void:
	if direction == 1:
		_sprite_2d.flip_h = true
	_income_label.hide()
	_state = BoatState.ARRIVING
	_setup_visible_on_screen_notifier_2d()


func _physics_process(delta: float) -> void:
	if _state == BoatState.IDLE:
		return
		
	position.x += SPEED * delta * direction

	if _state == BoatState.LEAVING:
		return
	
	var sprite_width: float = _sprite_2d.texture.get_width() * _sprite_2d.scale.x
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


func _setup_visible_on_screen_notifier_2d() -> void:
	var sprite_size: Vector2 = _sprite_2d.texture.get_size()
	_visible_on_screen_notifier_2d.rect = Rect2(
		-sprite_size/2,
		sprite_size
	)


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	leaved.emit(direction)
	queue_free()


func _dock() -> void:
	_income_label.text = str(income) + " €"
	_animation_player.play("get_income")
	docked.emit(income)
	
	_state = BoatState.IDLE
	_idle_timer.start(IDLE_TIME)
