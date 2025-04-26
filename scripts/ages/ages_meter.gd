extends Node2D
class_name AgeMeter

@export var bar_scene: PackedScene
@export var ages_years: Array[String]

@onready var first_year: Label = $FirstYear

var bars: Array[AgeBar] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var high_ages: Array[String] = ages_years.duplicate()
	var year_0: String = high_ages.pop_front()
	first_year.text = year_0
	first_year.self_modulate = Color(Color.WHITE, 0);
	
	for index in range(high_ages.size()):
		var year := high_ages[index]
		var age_bar: AgeBar = bar_scene.instantiate()
		age_bar.date_txt = year;
		age_bar.position.y = -State.AGE_HEIGHT * (index + 1)
		add_child(age_bar)
		bars.append(age_bar)
		
	State.update_age.connect(on_new_age)
	State.game_started.connect(on_start_game)

func on_new_age(age: int):
	var bar = bars[age - 1];
	bar.activate()
	
func on_start_game():
	var tween = create_tween()
	tween.tween_property(first_year, "self_modulate", Color.WHITE, 1.5
		).set_ease(Tween.EASE_IN_OUT
		).set_trans(Tween.TRANS_SINE)
