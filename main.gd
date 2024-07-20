extends Node2D

func _ready():
	PlayerVariables.connect("dead", on_death)

func on_death():
	get_tree().paused = true
	$UI/Control/MarginContainer/MarginContainer/UpgradePanel.show()
