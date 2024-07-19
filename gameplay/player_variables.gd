extends Node

#player stats
@export var resource_amount := 0
@export var max_hp := 155555.0
var current_hp := max_hp
@export var blink_count := 3
@export var blink_time := 1.0
@export var can_eat_fish = false
@export var can_eat_birds = false
@export var can_eat_fruit = false
@export var can_eat_mice = false
@export var can_eat_worms = true


#enemy stats
@export var min_flock = 2
@export var num_boids = 30

#map data
@export var islands := [
	Vector2(7400, 7272),
	Vector2(8120, 6975),
	Vector2(6840, 6584),
	Vector2(6624, 6944),
	Vector2(7464, 6472),
	Vector2(6640, 7488),
	Vector2(6224, 7608),
	Vector2(6120, 6696),
	Vector2(6176, 5952),
	Vector2(8112, 6016),
	Vector2(8120, 6488),
	Vector2(8744, 6844),
	Vector2(8768, 7360),
	Vector2(8696, 7936),
	Vector2(8176, 7536),
]
