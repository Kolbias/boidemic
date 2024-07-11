extends Node2D

var numBoids := 60

func _ready():
	var screensize = get_viewport_rect().size
	
	var player : CharacterBody2D = preload("res://gameplay/player.tscn").instantiate()
	add_child(player)
	player.position = Vector2(screensize.x / 2, screensize.y / 2)
	
	for i in numBoids:
		var boid : Area2D = preload("res://gameplay/enemy_boid.tscn").instantiate()
		add_child(boid)
		
		var x = randf_range(0, screensize.x)
		var y = randf_range(0, screensize.y)
		
		while Vector2(x, y).distance_to(Vector2(screensize.x / 2, screensize.y / 2)) < 150:
			x = randf_range(0, screensize.x)
			y = randf_range(0, screensize.y)
		
		boid.position = Vector2(x, y)
		
		if i == 1:
			boid.goodBoid = true
			boid.modulate = Color(1, 0, 0)

func _process(_delta):
	pass
