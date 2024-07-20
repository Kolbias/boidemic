extends Node2D

@export var game : PackedScene

func _ready():
	PlayerVariables.connect("dead", on_death)
	PlayerVariables.connect("reset", on_reset)

func on_death():
	get_tree().paused = true
	$UI/Control/MarginContainer/MarginContainer/UpgradePanel.show()

func on_reset():
	set_player_values()
	if get_tree().paused == true:
		get_tree().paused = false
	$MainMap/BirdBrain.reset()

func set_player_values():
	var player = PlayerVariables
	player.max_hp = player.default_hp + (player.upgrade_levels["max_hp"] * 10)
	player.max_speed = player.default_speed + (player.upgrade_levels["max_speed"] * 3)
	player.blink_count = player.default_blinks + player.upgrade_levels["blink_count"]
	player.blink_time = player.default_blink_time + (player.upgrade_levels["blink_time"] * 0.5)
	player.min_flock = player.default_flock + player.upgrade_levels["min_flock"]
	
	match player.upgrade_levels["food_level"]:
		1:
			player.can_eat_mice = true
		2:
			player.can_eat_mice = true
			player.can_eat_crab = true
		3:
			player.can_eat_mice = true
			player.can_eat_crab = true
			player.can_eat_fish = true
		4:
			player.can_eat_mice = true
			player.can_eat_crab = true
			player.can_eat_fish = true
			player.can_eat_birds = true
