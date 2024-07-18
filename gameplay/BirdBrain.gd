extends Node2D

const playerSceneConst : PackedScene = preload("res://gameplay/player.tscn")
const boidConst : PackedScene = preload("res://gameplay/enemy_boid.tscn")

@onready var parentScene := get_parent()
@onready var spawn_state := SpawnState.SPAWNING
@onready var screensize = parentScene.get_viewport_rect().size
@onready var boidTree := Quadtree.new(Rect2(0, 0, screensize.x, screensize.y))
@onready var playerFog := Quadtree.new(Rect2(0, 0, screensize.x, screensize.y))
@onready var islands := PlayerVariables.islands
var targetNumBoids = PlayerVariables.num_boids
var firstBoid = true
var spawnCooldown = 0.0

#this gets the node named Player from the parent scene
@onready var player : CharacterBody2D = parentScene.get_children().filter(func(node): return node.name == "Player")[0]

enum SpawnState {
	SPAWNING,
	CULLING
}

var boidArray = []

#debug drawing
func _draw():
	for island in islands:
		draw_circle(island, 10, Color.RED)

# Called when the node enters the scene tree for the first time.
func _ready():
	
	#player = playerSceneConst.instantiate()
	#parentScene.add_child.call_deferred(player)
	#player.position = screensize / 2
	
	while boidArray.size() < targetNumBoids:
		var x = randf_range(0, screensize.x)
		var y = randf_range(0, screensize.y)
		
		while Vector2(x, y).distance_to(Vector2(screensize.x / 2, screensize.y / 2)) < 150:
			x = randf_range(0, screensize.x)
			y = randf_range(0, screensize.y)
		
		spawnBoidInit(Vector2(x, y))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if boidArray.size() > targetNumBoids:
		spawn_state = SpawnState.CULLING
	else:
		spawn_state = SpawnState.SPAWNING
	
	match spawn_state:
		SpawnState.SPAWNING:
			spawnBoid()
		SpawnState.CULLING:
			if spawnCooldown == 0:
				cullBoids()
	spawnCooldown = max(0, spawnCooldown - delta)

func spawnBoidInit(point : Vector2):
	var newBoid = boidConst.instantiate()
	parentScene.add_child.call_deferred(newBoid)
	boidArray.append(newBoid)
	newBoid.position = point

func spawnBoid():
	spawnCooldown = 2.0
	var islands = PlayerVariables.islands
	var nearestIsland = islands[0]
	var pos = player.position
	for center in islands:
		if pos.distance_to(center) < pos.distance_to(nearestIsland):
			nearestIsland = center
	var newBoid = boidConst.instantiate()
	parentScene.add_child.call_deferred(newBoid)
	boidArray.append(newBoid)
	newBoid.position = nearestIsland

func cullBoids():
	boidArray.sort_custom(boidSort)
	while boidArray.size() > targetNumBoids:
		boidArray.back().queue_free()
		boidArray.pop_back()

func boidSort(a : Enemy_Boid, b : Enemy_Boid):
	var pos = player.position
	if a.position.distance_to(pos) > b.position.distance_to(pos):
		return false
	return true
