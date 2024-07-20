extends Node2D

@export var game : PackedScene

func _ready():
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
