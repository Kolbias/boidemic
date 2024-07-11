extends CharacterBody2D

var hostiles := []
var identifiedFood := []
var onLand : bool = false
var timeAtSea : float = 0
const islands := [
	Vector2(280, 160),
	Vector2(170, 370),
	Vector2(550, 270),
	Vector2(450, 550)
	]

var vel := Vector2.ZERO
var speed := 15.0
const minSpeed := 15.0
const maxSpeed := 80.0

@onready var screensize := get_viewport_rect().size
@onready var size : float = $BodyCollision.shape.radius

func _ready():
	var startRotation := randf_range(0, TAU)
	global_rotation = startRotation
	
	vel = Vector2.from_angle(rotation)

func _physics_process(delta):
	#avoid enemies
	if hostiles:
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

## Placeholder Mouse Movement
#func _process(delta):
	#look_at(get_global_mouse_position())
#
#func _physics_process(delta):
	#var vel : Vector2 = get_global_mouse_position() - global_position
	#velocity = vel
	#move_and_slide()

func _on_field_of_view_area_entered(area):
	if area.is_in_group("enemyBoid"):
		hostiles.append(area)

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

func _on_body_area_exited(area):
	if area.is_in_group("island"):
		onLand = false

func collect(item_value):
	PlayerVariables.resource_amount += item_value

