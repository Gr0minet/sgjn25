class_name UI
extends Control


@onready var _money_label: Label = $MarginContainer/MoneyLabel


func set_money_label(amount: int) -> void:
	_money_label.text = str(amount) + " €"
