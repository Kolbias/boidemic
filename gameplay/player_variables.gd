extends Node

signal dead
signal reset
signal victory

#player stats
@export var resource_amount := 0
@export var max_hp := 50.0
var current_hp := max_hp
var remaining_blinks := blink_count
@export var blink_count := 1
@export var blink_time := 0.5
@export var can_eat_fish = false
@export var can_eat_birds = false
@export var can_eat_crab = false
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
	[2, 3],
	[2, 3],
	[5, 10],
	[5, 10],
	[5, 10],
	[10, 25, 75, 400, 1500]
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
const default_speed := 65.0
const default_blinks := 1
const default_blink_time := 0.5
const default_flock := 2
var num_generations = 1
