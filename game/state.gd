extends Node

signal update_height_reached(value: float)
signal update_age(age: float)

signal money_changed(new_value: int)

enum Value {MAIN_MENU, PLAYING}
var AGE_HEIGHT := 700.0
var MAX_AGE = 3

var current: State.Value
var height_reached := 0.0
var age := 0

func set_height_reached(height: float):
	height_reached = height
	update_height_reached.emit(height)
	
	if height_reached > float(age) * AGE_HEIGHT && age < MAX_AGE:
		age += 1
		update_age.emit(age)
var money: int = 0:
	set(value):
		money = value
		money_changed.emit(value)
