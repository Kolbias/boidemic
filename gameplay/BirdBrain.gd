extends Node

const playerSceneConst : PackedScene = preload("res://gameplay/player.tscn")
const boidConst : PackedScene = preload("res://gameplay/enemy_boid.tscn")

@onready var parentScene := get_parent()
@onready var spawn_state := SpawnState.SPAWNING
@onready var screensize = parentScene.get_viewport_rect().size
@onready var boidTree := Quadtree.new(Rect2(0, 0, screensize.x, screensize.y))
@onready var playerFog := Quadtree.new(Rect2(0, 0, screensize.x, screensize.y))
@onready var islands = parentScene.islands

@export var targetNumBoids = 40

var player : CharacterBody2D

enum SpawnState {
	SPAWNING,
	CULLING
}

var boidArray = []

# Called when the node enters the scene tree for the first time.
func _ready():
	player = playerSceneConst.instantiate()
	parentScene.add_child.call_deferred(player)
	player.position = screensize / 2
	player.islands = islands
	
	while boidArray.size() < targetNumBoids:
		var x = randf_range(0, screensize.x)
		var y = randf_range(0, screensize.y)
		
		while Vector2(x, y).distance_to(Vector2(screensize.x / 2, screensize.y / 2)) < 150:
			x = randf_range(0, screensize.x)
			y = randf_range(0, screensize.y)
		
		spawnBoid(Vector2(x, y))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if boidArray.size() > targetNumBoids:
		spawn_state = SpawnState.CULLING
	else:
		spawn_state = SpawnState.SPAWNING
	
	match spawn_state:
		SpawnState.SPAWNING:
			pass
		SpawnState.CULLING:
			cullBoids()
	


func spawnBoid(point : Vector2):
	var newBoid = boidConst.instantiate()
	parentScene.add_child.call_deferred(newBoid)
	boidArray.append(newBoid)
	newBoid.position = point
	newBoid.islands = islands

func cullBoids():
	pass

