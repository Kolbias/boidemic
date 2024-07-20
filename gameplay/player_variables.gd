extends Node

signal dead

#player stats
@export var resource_amount := 100
@export var max_hp := 1.0
var current_hp := max_hp
@export var blink_count := 3
@export var blink_time := 1.0
@export var can_eat_fish = false
@export var can_eat_birds = true
@export var can_eat_fruit = false
@export var can_eat_mice = false
@export var max_speed = 22.0
const can_eat_worms = true

var upgrade_levels = {
	"max_hp" : 0,
	"max_speed" : 0,
	"blink_count" : 0,
	"blink_time" : 0,
	"min_flock" : 0,
	"food_level" : 0
}

var upgrade_prices = [
	[0, 1],
	[1, 2, 3, 4, 5],
	[1, 2, 3, 4, 5],
	[1, 2, 3, 4, 5],
	[1, 2, 3, 4, 5],
	[1, 2, 3, 4, 5]
]

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

const default_res := 0
const default_hp := 50.0
const default_blinks := 1
const default_blink_time := 1.0
const default_flock := 2

func _on_upgrade_stat():
	print("Health Increased or some shit idk")

