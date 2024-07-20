extends CharacterBody2D
class_name Player

signal ate_boid(boid)

var hostiles := []
var identifiedFood := []
var onLand : bool = true
var timeAtSea : float = 0
var islands = PlayerVariables.islands.duplicate()
var visitedIslands := []
var retargetTime := 0.0
var retargetBool = true
var attackCooldown = 0.0
var taken_hit := 0.5

var vel := Vector2.ZERO
var speed := 15.0
var lifeTime = 0.0
const minSpeed := 15.0
var maxSpeed := 0.0
const viewRect := Rect2(0, 0, 320, 320)

@onready var screensize := get_viewport_rect().size
@onready var size : float = $BodyCollision.shape.radius

var blinkTime := 0.0

enum BlinkState {
	DEFAULT,
	BLINK
}
var blinkState := BlinkState.DEFAULT
var blinkStateTimer := 0.0

enum PathingState {
	DEFAULT,
	AGGRESSIVE
}
var pathingState := PathingState.DEFAULT


func set_player_values():
	var player = PlayerVariables
	player.max_hp = player.default_hp + (player.upgrade_levels["max_hp"] * 10)
	player.max_speed = player.default_speed + (player.upgrade_levels["max_speed"] * 6)
	player.blink_count = player.default_blinks + player.upgrade_levels["blink_count"]
	player.blink_time = player.default_blink_time + (player.upgrade_levels["blink_time"] * 0.5)
	player.min_flock = player.default_flock + player.upgrade_levels["min_flock"]
	
	match player.upgrade_levels["food_level"]:
		1:
			player.can_eat_mice = true
		2:
			player.can_eat_mice = true
			player.can_eat_fish = true
		3:
			player.can_eat_mice = true
			player.can_eat_crab = true
			player.can_eat_fish = true
		4:
			player.can_eat_mice = true
			player.can_eat_crab = true
			player.can_eat_fish = true
			player.can_eat_birds = true


func _ready():
	set_player_values()
	islands.sort_custom(islandSort)
	var startRotation := randf_range(0, TAU)
	global_rotation = startRotation
	vel = Vector2.from_angle(rotation)
	
	PlayerVariables.current_hp = PlayerVariables.max_hp

	PlayerVariables.remaining_blinks = PlayerVariables.blink_count
	blinkTime = PlayerVariables.blink_time
	maxSpeed = PlayerVariables.max_speed

func _physics_process(delta):
	#modulate = Color(1,1,1,1)
	#debug to show pathing state
	#if pathingState == PathingState.AGGRESSIVE:
		#modulate = Color(1, 0, 0, 1)
	#elif blinkState == BlinkState.BLINK:
		#modulate = Color(0, 0, 1, 1)
	#else:
		#modulate = Color(1, 1, 1, 1)
	
	#print("hp: " + str(hp) + " currentHp " + str(PlayerVariables.current_hp))
	
	#are you dead?
	if PlayerVariables.current_hp < 0:
		PlayerVariables.dead.emit()
		hide()
	
	#eat known food
	if identifiedFood:
		#print("I am targeting known food")
		if identifiedFood.front() != null:
			var target = identifiedFood.front()
			vel += (target.global_position - global_position).normalized()
		
	else:
		#look for food
		#print("I am looking for food")
		var target
		if retargetBool:
			islands.sort_custom(islandSort)
			retargetBool = false
		#if retargetTime == 0:
			#islands.sort_custom(islandSort)
			#retargetTime = 1.0
		if visitedIslands.size() == islands.size():
			print("new grand tour!")
			visitedIslands.clear()
		for i in islands:
			if !visitedIslands.has(i):
				target = i
				#print("targeting " + str(target))
				break
		vel += (target - global_position).normalized()
		if global_position.distance_to(target) < 1000:
			#print("saw an island")
			retargetBool = true
			visitedIslands.append(target)
	
	#avoid enemies
	if !PlayerVariables.can_eat_birds and hostiles\
	or PlayerVariables.current_hp < 50:
		for enemy in hostiles:
			var repulsion : Vector2 = (global_position - enemy.global_position) \
			/ global_position.distance_squared_to(enemy.global_position)
				
			vel += repulsion
	elif PlayerVariables.can_eat_birds and hostiles and is_zero_approx(attackCooldown):
		pathingState = PathingState.AGGRESSIVE
		var closest = hostiles[0]
		var dist = global_position.distance_to(closest.global_position)
		for enemy in hostiles:
			var newDist = global_position.distance_to(enemy.global_position)
			if newDist < dist:
				dist = newDist
		var hunt : Vector2 = closest.global_position - global_position
		vel = hunt.normalized()
	else:
		pathingState = PathingState.DEFAULT
	
	#stay on land
	if !onLand:
		vel += landBias(delta)
	
	vel = vel.normalized()
	
	var newFacing = lerp_angle(
		global_rotation, Vector2.ZERO.angle_to_point(vel), 1
		)
	
	if abs(newFacing - rotation) < PI / 6:
		speed = min(maxSpeed, speed * 1.1)
	elif abs(newFacing - rotation) >= PI / 3:
		speed = max(minSpeed, speed * 0.8)
	
	rotation = newFacing
	
	vel = Vector2.from_angle(rotation).normalized()
	var bonus = 1
	if blinkState == BlinkState.BLINK:
		bonus = 2
	global_position += vel * speed * delta * bonus
	
	blinkStateManager(delta * -1)
	lifeTime += delta
	retargetTime = max(0.0, retargetTime - delta)
	attackCooldown = max(0.0, attackCooldown - delta)
	PlayerVariables.current_hp += delta * (lifeTime * -1)
	taken_hit = max(0.0, taken_hit - delta)
	if taken_hit == 0.0:
		modulate = lerp(Color(1,0,0,1), Color(1,1,1,1), 1.0)

func _on_field_of_view_area_entered(area):
	if area.is_in_group("enemyBoid"):
		hostiles.append(area)

func _on_field_of_view_area_exited(area):
	if area.is_in_group("enemyBoid"):
		hostiles.erase(area)

func landBias(delta : float) -> Vector2:
	if islands.size() == 0: return Vector2.ZERO
	timeAtSea += delta
	var nearestIsland = islands[0]
	
	for center in islands:
		if global_position.distance_to(
			center) < global_position.distance_to(nearestIsland):
			nearestIsland = center
	#print("heading to shore at coordinates " + str(nearestIsland))
	return (nearestIsland - global_position).normalized() * timeAtSea / 10

func _on_body_area_entered(area):
	if area.is_in_group("island"):
		#print("I am ashore!")
		onLand = true
		timeAtSea = 0
	elif area.is_in_group("food"):
		if area.is_in_group("worm") and PlayerVariables.can_eat_worms or \
		area.is_in_group("fish") and PlayerVariables.can_eat_fish or \
		area.is_in_group("mouse") and PlayerVariables.can_eat_mice or \
		area.is_in_group("crab") and PlayerVariables.can_eat_crab:
			consume(area.resource_value)
			identifiedFood.erase(area)
			area.queue_free()
	elif area.is_in_group("enemyBoid"):
		if blinkState == BlinkState.DEFAULT:
			modulate = lerp(Color(1,1,1,1), Color(1,0,0,1), 1.0)
			taken_hit = 0.5
			PlayerVariables.current_hp += -5
			blinkStateManager(1)
			if PlayerVariables.can_eat_birds:
				eatBoid(area)

func _on_body_area_exited(area):
	if area.is_in_group("island"):
		#print("I am at sea")
		onLand = false

func consume(value : int):
	PlayerVariables.current_hp += value
	PlayerVariables.resource_amount += value

func eatBoid(boid):
	attackCooldown = 1.0
	consume(100)
	ate_boid.emit(boid)

func blinkStateManager(duration : float):
	if blinkState == BlinkState.DEFAULT and duration > 0:
		blinkState = BlinkState.BLINK
		blinkStateTimer = duration
	elif blinkState == BlinkState.BLINK:
		blinkStateTimer += duration
		if blinkStateTimer < 0:
			blinkState = BlinkState.DEFAULT
			pathingState = PathingState.DEFAULT

func _unhandled_input(event):
	if event is InputEventMouseButton and event.pressed:
		#print(event)
		if PlayerVariables.remaining_blinks > 0:
			PlayerVariables.remaining_blinks -= 1
			pathingState = PathingState.AGGRESSIVE
			blinkStateManager(blinkTime)

func _on_food_radar_area_entered(area):
	if area.is_in_group("food") and !identifiedFood.has(area):
		if area.is_in_group("worm") and PlayerVariables.can_eat_worms or \
		area.is_in_group("fish") and PlayerVariables.can_eat_fish or \
		area.is_in_group("mouse") and PlayerVariables.can_eat_mice or \
		area.is_in_group("crab") and PlayerVariables.can_eat_crab:
			identifiedFood.append(area)
			identifiedFood.sort_custom(areaSort)

func areaSort(a : Area2D, b : Area2D):
	var pos = global_position
	if a.position.distance_to(pos) > b.position.distance_to(pos):
		return false
	return true

func islandSort(a : Vector2, b : Vector2):
	var pos = global_position
	if a.distance_to(pos) > b.distance_to(pos):
		return false
	return true
