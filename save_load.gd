extends Node

const SAVE_PATH = "user://save_config_file.ini"

func save_game():
	var config := ConfigFile.new()
	var player := get_node(^"/root/PlayerVariables") as Player
	config.set_value("player", "upgrades", player.upgrade_levels)
	config.set_value("player", "resources", player.resources)
	
	config.save(SAVE_PATH)


#will this overwrite in a bad way on the first load?  note to check
func load_game():
	var config := ConfigFile.new()
	config.load(SAVE_PATH)
	var player := get_node(^"/root/PlayerVariables") as Player
	player.upgrade_levels = config.get_value("player", "upgrades")
	player.resources = config.get_value("player", "resources")
	
	player.max_hp = player.default_hp + (player.upgrade_levels("max_hp") * 10)
	player.max_speed = player.default_speed + (player.upgrade_levels("max_speed") * 3)
	player.blink_count = player.default_blinks + player.upgrage_levels("blink_count")
	player.blink_time = player.default_blink_time + (player.upgrade_levels("blink_time") * 0.5)
	player.min_flock = player.default_flock + player.upgrade_levels("min_flock")
	
	match player.upgrade_levels("food_level"):
		1:
			player.can_eat_mice = true
		2:
			player.can_eat_mice = true
			player.can_eat_fruit = true
		3:
			player.can_eat_mice = true
			player.can_eat_fruit = true
			player.can_eat_fish = true
		4:
			player.can_eat_mice = true
			player.can_eat_fruit = true
			player.can_eat_fish = true
			player.can_eat_birds = true
