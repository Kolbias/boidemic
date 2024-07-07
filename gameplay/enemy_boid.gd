extends Area2D

var vel := Vector2.ZERO
var speed := 1.0

func _ready():
	randomize()
	var size = get_viewport_rect().size
	global_position = Vector2(
		randf_range(0, size.x),
		randf_range(0, size.y)
	)
	var startRotation = randf_range(0, 2 * PI)
	global_rotation = startRotation
	vel = Vector2.from_angle(rotation)

func _process(_delta):
	vel = vel.normalized() * speed
	move()

func move():
	global_position += vel
