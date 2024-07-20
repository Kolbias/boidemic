extends Node2D

signal music_toggle

@export var game : PackedScene

func _ready():
	connect("music_toggle", _on_music_toggle)
	PlayerVariables.connect("dead", on_death)
	PlayerVariables.connect("reset", on_reset)
	PlayerVariables.connect("victory", on_victory)

func on_death():
	get_tree().paused = true
	$UI/Control/MarginContainer/MarginContainer/UpgradePanel.show()

func on_reset():
	PlayerVariables.num_generations += 1
	if get_tree().paused == true:
		get_tree().paused = false
	$MainMap/BirdBrain.reset()

func on_victory():
	get_tree().paused = true
	print("winner")
	print(PlayerVariables.num_generations)

func _on_music_toggle():
	if $MusicSFX.playing:
		$MusicSFX.stop()
	else:
		$MusicSFX.play()
