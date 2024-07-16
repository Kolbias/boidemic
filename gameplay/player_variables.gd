extends Node

#player stats
var resource_amount := 0
var max_hp = 3
var blink_count := 3
var blink_time := 1.0
var can_eat_fish = false
var can_eat_birds = false
var can_eat_fruit = false

#enemy stats
var min_flock = 4
var num_boids = 30

#map data
const islands := [
	Vector2(280, 160),
	Vector2(170, 370),
	Vector2(550, 270),
	Vector2(450, 550)
]
