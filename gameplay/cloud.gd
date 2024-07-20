extends Node2D

var rand_pos_x 
var rand_pos_y
var rand_speed_x = randf_range(-0.5, -1)
var rand_speed_y = randf_range(0.5, 1)
var sprites = ["1","2","3"]

func _ready():
	$AnimatedSprite2D.play(sprites.pick_random())

func _process(delta):
	global_position += Vector2(rand_speed_x, rand_speed_y)
	if global_position.y > 9000 or global_position.x < 5000:
		var new_pos = get_rand_pos()
		global_position = new_pos

func get_rand_pos() -> Vector2:
	rand_pos_x = randi_range(7000, 10000)
	rand_pos_y = randi_range(4000, 5000)
	return Vector2(rand_pos_x,rand_pos_y)

