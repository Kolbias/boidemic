extends CharacterBody2D
class_name Player

var hostiles := []
var identifiedFood := []
var onLand : bool = false
var timeAtSea : float = 0
var islands := PlayerVariables.islands

var vel := Vector2.ZERO
var speed := 15.0
var lifeTime = 0.0
const minSpeed := 15.0
const maxSpeed := 80.0
const viewRect := Rect2(0, 0, 320, 320)

@onready var screensize := get_viewport_rect().size
@onready var size : float = $BodyCollision.shape.radius
@onready var fog := Quadtree.new(
	Rect2(Vector2.ZERO, Vector2(screensize.x, screensize.y))
	)

var hp := 0.0
var blinks := 0
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

func _ready():
	var startRotation := randf_range(0, TAU)
	global_rotation = startRotation
	vel = Vector2.from_angle(rotation)
	
	hp = PlayerVariables.max_hp
	blinks = PlayerVariables.blink_count
	blinkTime = PlayerVariables.blink_time

func _physics_process(delta):
	#debug to show pathing state
	if pathingState == PathingState.AGGRESSIVE:
		modulate = Color(1, 0, 0, 1)
	elif blinkState == BlinkState.BLINK:
		modulate = Color(0, 0, 1, 1)
	else:
		modulate = Color(1, 1, 1, 1)
	
	#are you dead?
	if hp < 0:
		speed = 0
	
	#eat known food
	if identifiedFood:
		var target = identifiedFood.front()
		vel += (target.position - position).normalized()
		
	else:
		#look for food
		pass
	
	
	#avoid enemies
	if pathingState == PathingState.DEFAULT and hostiles:
		for enemy in hostiles:
			var repulsion : Vector2 = (position - enemy.position) / position.distance_squared_to(enemy.position)
			vel += repulsion
	
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
	position += vel * speed * delta * bonus
	
	blinkStateManager(delta * -1)
	lifeTime += delta
	hp -= delta * (lifeTime)
	print(global_position)

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
		if position.distance_to(center) < position.distance_to(nearestIsland):
			nearestIsland = center
	
	return (nearestIsland - position).normalized() * timeAtSea / 10

func _on_body_area_entered(area):
	if area.is_in_group("island"):
		onLand = true
		timeAtSea = 0
	elif area.is_in_group("food"):
		consume(area.resource_value)
		identifiedFood.erase(area)
		area.queue_free()
	elif area.is_in_group("enemyBoid"):
		if blinkState == BlinkState.DEFAULT:
			hp -= 1
			print(hp)
			blinkStateManager(1)

func _on_body_area_exited(area):
	if area.is_in_group("island"):
		onLand = false

func consume(value : int):
	PlayerVariables.resource_amount += value
	hp += value

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
		print(event)
		if blinks > 0:
			blinks -= 1
			pathingState = PathingState.AGGRESSIVE
			blinkStateManager(blinkTime)

func _on_food_radar_area_entered(area):
	if area.is_in_group("food") and !identifiedFood.has(area):
		identifiedFood.append(area)
		identifiedFood.sort_custom(areaSort)
		print(area)

func areaSort(a : Area2D, b : Area2D):
	var pos = position
	if a.position.distance_to(pos) > b.position.distance_to(pos):
		return false
	return true
