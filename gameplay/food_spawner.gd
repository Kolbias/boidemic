extends Node2D

@export var foods : Array[PackedScene] = []
@export var max_foods := 10
@export var min_rand_time := 5.0
@export var max_rand_time := 15.0
@export var spawn_area_x := 100.0
@export var spawn_area_y := 100.0
@export var view_spawn_area := false

var food_counter = 0

func _ready():
	min_rand_time = 8.0
	max_rand_time = 15.0
	set_max_spawns()
	
	while food_counter < max_foods / 2:
		forceSpawn()
	
	if view_spawn_area:
		$Area.show()
	else:
		$Area.hide()
	$Area.size.x = spawn_area_x
	$Area.size.y = spawn_area_y
	$Timer.wait_time = randf_range(min_rand_time, max_rand_time)
	$Timer.start()

func _on_timer_timeout():
	#if food_counter > 0:
		#food_counter = $FoodCount.get_child_count()
	if food_counter < max_foods:
		var new_food = foods.pick_random().instantiate()
		$FoodCount.add_child(new_food)
		food_counter = $FoodCount.get_child_count()
		new_food.position.x = randf_range(0, spawn_area_x)
		new_food.position.y = randf_range(0, spawn_area_y)
		min_rand_time += 0.5
		max_rand_time += 1.0

func set_max_spawns():
	var area = spawn_area_x * spawn_area_y
	max_foods = ceil(log(area))

func forceSpawn():
	var new_food = foods.pick_random().instantiate()
	$FoodCount.add_child(new_food)
	food_counter = $FoodCount.get_child_count()
	new_food.position.x = randf_range(0, spawn_area_x)
	new_food.position.y = randf_range(0, spawn_area_y)

func printInfo():
	print("contains " + str(food_counter) + " with a max of " + str(max_foods) + " spawning every " + str(min_rand_time) + 
	" to " + str(max_rand_time) + " .")
