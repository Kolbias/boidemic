extends Node2D

var numBoids := 40

# Called when the node enters the scene tree for the first time.
func _ready():
	var screensize = get_viewport_rect().size
	for i in numBoids:
		var boid : Area2D = preload("res://gameplay/enemy_boid.tscn").instantiate()
		add_child(boid)
		
		#var spawn = Vector2.ZERO
		#var validSpawn = false
		#
		#while true:
			#spawn = Vector2(
			#randf_range(0, screensize.x),
			#randf_range(0, screensize.y)
			#)
			#for island in $TestMap/Islands.get_children():
				#var isle = island.get_child(0).polygon
				#if Geometry2D.is_point_in_polygon(spawn, isle):
					#validSpawn = true
					#break
			#if validSpawn:
				#break
		#
		#boid.position = spawn
		
		boid.position = Vector2(
			randf_range(0, screensize.x),
			randf_range(0, screensize.y)
			)
		
		if i == 1:
			boid.goodBoid = true
			boid.modulate = Color(1, 0, 0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
