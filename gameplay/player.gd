extends CharacterBody2D
class_name Player

var hostiles := []
var identifiedFood := []
var onLand : bool = false
var timeAtSea : float = 0
var islands := [Vector2.ZERO]

var vel := Vector2.ZERO
var speed := 15.0
const minSpeed := 15.0
const maxSpeed := 80.0
const viewRect := Rect2(0, 0, 320, 320)

@onready var screensize := get_viewport_rect().size
@onready var size : float = $BodyCollision.shape.radius
@onready var fog := Quadtree.new(Rect2(Vector2.ZERO, Vector2(screensize.x, screensize.y)))

var hp := 0
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
	if pathingState == PathingState.AGGRESSIVE:
		modulate = Color(1, 0, 0, 1)
	elif blinkState == BlinkState.BLINK:
		modulate = Color(0, 0, 1, 1)
	else:
		modulate = Color(1, 1, 1, 1)
	
	if hp < 1:
		speed = 0
	
	#avoid enemies
	if pathingState == PathingState.DEFAULT and hostiles:
		for enemy in hostiles:
			var repulsion : Vector2 = (position - enemy.position) / position.distance_squared_to(enemy.position)
			vel += repulsion
	
	if !onLand:
		vel += landBias(delta)
	
	#eat known food
	#look for food
	
	vel = vel.normalized()
	
	var newFacing = lerp_angle(global_rotation, Vector2.ZERO.angle_to_point(vel), 1)
	
	if abs(newFacing - rotation) < PI / 6:
		speed = min(maxSpeed, speed * 1.1)
	elif abs(newFacing - rotation) >= PI / 3:
		speed = max(minSpeed, speed * 0.8)
	
	rotation = newFacing
	
	vel = Vector2.from_angle(rotation).normalized()
	
	position += vel * speed * delta
	wrapAround()
	blinkStateManager(delta * -1)

func _on_field_of_view_area_entered(area):
	if area.is_in_group("enemyBoid"):
		hostiles.append(area)
	elif area.is_in_group("food"):
		identifiedFood.append(area)

func _on_field_of_view_area_exited(area):
	if area.is_in_group("enemyBoid"):
		hostiles.erase(area)

func wrapAround():
	if position.x < 0:
		position.x = screensize.x
	if position.y < 0:
		position.y = screensize.y
	if position.x > screensize.x:
		position.x = 0
	if position.y > screensize.y:
		position.y = 0

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
		identifiedFood.erase(area)
	elif area.is_in_group("enemyBoid"):
		if blinkState == BlinkState.DEFAULT:
			hp -= 1
			print(hp)
			blinkStateManager(1)
		else:
			print("phew!")

func _on_body_area_exited(area):
	if area.is_in_group("island"):
		onLand = false

func collect(item_value):
	PlayerVariables.resource_amount += item_value

func consume(value : int):
	pass

func _on_input_event(viewport, event, shape_idx):
	print(event)
	if event is InputEventMouseButton:
		if blinks > 0:
			blinks -= 1
			pathingState = PathingState.AGGRESSIVE
			blinkStateManager(blinkTime)
			print("manual blink!")
		else:
			print("out of blinks!")

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
			print("manual blink!")
		else:
			print("out of blinks!")
