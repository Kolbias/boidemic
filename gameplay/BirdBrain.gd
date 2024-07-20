extends Node2D

const playerSceneConst : PackedScene = preload("res://gameplay/player.tscn")
const boidConst : PackedScene = preload("res://gameplay/enemy_boid.tscn")

@onready var parentScene := get_parent()
@onready var spawn_state := SpawnState.SPAWNING
@onready var screensize = parentScene.get_viewport_rect().size
@onready var islands := PlayerVariables.islands.duplicate()
@onready var targetNumBoids = PlayerVariables.num_boids
var firstBoid = true
var spawnCooldown := 0.0

#this gets the node named Player from the parent scene
@onready var player : CharacterBody2D = parentScene.get_children()\
	.filter(func(node): return node.name == "Player")[0]

enum SpawnState {
	SPAWNING,
	CULLING
}

var boidArray = []

func reset():
	#for boid in boidArray:
		#boid.queue_free()
		#boidArray.erase(boid)
	get_tree().reload_current_scene()
	#player.queue_free()
	#player = playerSceneConst.instantiate()
	#_ready()
	

# Called when the node enters the scene tree for the first time.
func _ready():
	
	#player = playerSceneConst.instantiate()
	#parentScene.add_child.call_deferred(player)
	#player.position = screensize / 2
	
	while boidArray.size() < targetNumBoids:
		var x = randf_range(0, screensize.x)
		var y = randf_range(0, screensize.y)
		
		while Vector2(x, y)\
		.distance_to(Vector2(screensize.x / 2, screensize.y / 2)) < 150:
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
	newBoid.global_position = point
	newBoid.global_rotation = randf_range(0, TAU)

func spawnBoid():
	var nearestIsland = player.islands[0]
	var pos = player.global_position
	for center in islands:
		if pos.distance_to(center) < pos.distance_to(nearestIsland):
			nearestIsland = center
	var newBoid = boidConst.instantiate()
	parentScene.add_child(newBoid)
	boidArray.append(newBoid)
	newBoid.global_position = nearestIsland + Vector2(randi_range(-100, 100), randi_range(-100, 100))
	newBoid.global_rotation = Vector2.ZERO.angle_to_point(player.global_position)
	#print("spawned boid at " + str(nearestIsland))

func cullBoids():
	if targetNumBoids < 2:
		return
	boidArray.sort_custom(boidSort)
	while boidArray.size() > targetNumBoids:
		#print("culled boid")
		boidArray.back().queue_free()
		boidArray.pop_back()
		spawnCooldown = 100 / \
		boidArray.back().global_position.distance_to(player.global_position)

func boidSort(a : Enemy_Boid, b : Enemy_Boid):
	var pos = player.global_position
	if a.global_position.distance_to(pos) > b.global_position.distance_to(pos):
		return false
	return true

func islandSort(a : Vector2, b : Vector2):
	var pos = player.global_position
	if a.distance_to(pos) > b.distance_to(pos):
		return false
	return true


func _on_player_ate_boid(boid):
	boid.queue_free()
	boidArray.erase(boid)
	PlayerVariables.num_boids = max(0, PlayerVariables.num_boids - 1)
	targetNumBoids = PlayerVariables.num_boids
	for enemy in boidArray:
		if enemy.global_position.distance_to(player.global_position) < 200:
			enemy.vel += enemy.global_position - player.global_position / \
			(enemy.global_position.distance_squared_to(player.global_position))
	if PlayerVariables.num_boids == 0:
		PlayerVariables.victory.emit()
	print(targetNumBoids)
