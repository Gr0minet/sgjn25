extends Node2D
class_name MusicManager

@onready var player: AudioStreamPlayer = $AudioStreamPlayer
@onready var age_cue: AudioStreamPlayer = $AgeCue

@export var fade_duration := 2.0
@export var layers: Array[MusicLayer]

var syncstream: AudioStreamSynchronized

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	syncstream = player.stream
	for layer in layers:
		for idx in range(layer.nb):
			syncstream.set_sync_stream_volume(layer.from + idx, -60.0);
		
	State.update_age.connect(activate_layer)
	State.game_started.connect(start_music)
	State.update_age.connect(play_age_cue)

func activate_layer(layer_idx: int):
	if layer_idx >= State.MAX_AGE:
		return
	var layer := layers[layer_idx]
	var fade_tween = create_tween()
	fade_tween.tween_method(
		set_layer_volume.bind(layer),
		-60.0, 0.0, fade_duration)

func set_layer_volume(volume: float, layer: MusicLayer):
	for idx in range(layer.nb):
			syncstream.set_sync_stream_volume(layer.from + idx, volume);	

func start_music():
	syncstream.set_sync_stream_volume(0, 0.0);
	player.play()
	
func play_age_cue(_age: int):
	age_cue.play()
