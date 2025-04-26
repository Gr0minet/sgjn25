extends Node

signal update_height_reached(value: float)
signal update_age(age: int)
signal pirated(amount: int)
signal pirate_spawned(side: Boat.Side)
signal game_started

signal money_changed(new_value: int)

enum Value {MAIN_MENU, PLAYING}
var AGE_HEIGHT := 1400.0
var MAX_AGE = 3

var AGES_COLOR: Array[Color] = [
	Color("#795336"),
	Color("#938122"),
	Color("#657f3f"),
	Color("#008675"),
]

var current: State.Value
var height_reached := 0.0
var age := 0
var money: int = 0:
	set(value):
		money = value
		money_changed.emit(value)


func set_height_reached(height: float):
	height_reached = height
	update_height_reached.emit(height)
	
	if height_reached > (float(age + 1) * AGE_HEIGHT) && age < MAX_AGE:
		age += 1
		update_age.emit(age)


func start_game():
	current = State.Value.PLAYING
	game_started.emit()

func get_age_progression() -> float:
	if age == MAX_AGE: return 0.0
	
	var current_position := height_reached - (float(age) * AGE_HEIGHT)
	return current_position / AGE_HEIGHT
