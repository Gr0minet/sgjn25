extends Control
class_name AgeBar

@export var date_txt: String = "1800"

@onready var date_label: Label = $Date


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	date_label.text = date_txt
	date_label.self_modulate = Color(Color.WHITE, 0.0)

func activate():
	var tween = create_tween()
	tween.tween_property(date_label, "self_modulate", Color.WHITE, 1.5
		).set_ease(Tween.EASE_IN_OUT
		).set_trans(Tween.TRANS_SINE)
