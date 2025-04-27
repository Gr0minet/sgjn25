class_name SFXManager
extends Node


@onready var get_money_sfx: AudioStreamPlayer = $GetMoneyStreamPlayer
@onready var lose_money_sfx: AudioStreamPlayer = $LoseMoneyStreamPlayer
@onready var ship_sinked_sfx: AudioStreamPlayer = $ShipSinkedStreamPlayer
@onready var pirate_approach_sfx: AudioStreamPlayer = $PirateApproachStreamPlayer
@onready var block_build_sfx: AudioStreamPlayer = $BlockBuildStreamPlayer
@onready var block_drag_sfx: AudioStreamPlayer = $BlockPlacedStreamPlayer



func _ready() -> void:
	State.pirate_spawned.connect(func(_x) -> void: pirate_approach_sfx.play())
	State.pirated.connect(func(_x) -> void: lose_money_sfx.play())
	State.earn_money.connect(func() -> void: get_money_sfx.play())
	State.block_placed.connect(func() -> void: block_build_sfx.play())
	State.block_taken.connect(func() -> void: block_drag_sfx.play())
	State.ship_sinked.connect(func() -> void: ship_sinked_sfx.play())
