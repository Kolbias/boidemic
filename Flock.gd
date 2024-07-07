extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	
	for i in 10:
		randomize()
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func spawn():
	var boid = $enemy_boid
	add_child(boid)
	boid.global_position = Vector2(
		randf_range(0, 100),
		randf_range(0, 100)
	)
	print("boid")
	pass
