extends Node2D

var numBoids := 100

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in numBoids:
		var boid : Area2D = preload("res://gameplay/enemy_boid.tscn").instantiate()
		add_child(boid)
		if i == 1:
			boid.goodBoid = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
