extends Area2D

const islands := [
	Vector2(280, 160),
	Vector2(170, 370),
	Vector2(550, 270),
	Vector2(450, 550)
	]

var following := []
var vel := Vector2.ZERO

var speed := 15.0
const minSpeed := 15.0
const maxSpeed := 75.0

var onLand : bool = false
var timeAtSea : float = 0

var goodBoid = false

@onready var screensize := get_viewport_rect().size
@onready var boidSize : float = $BodyCollision.shape.radius
@onready var raycasts := $Raycasts.get_children()

func _ready():
	var startRotation := randf_range(0, TAU)
	global_rotation = startRotation
	
	vel = Vector2.from_angle(rotation)
	
	$BirdSprite.set_frame(randi_range(0,7))
	

func _physics_process(delta):
	var separation := Vector2.ZERO
	var alignment := Vector2.ZERO
	var cohesion := Vector2.ZERO
	
	if following:
		var numBirds := following.size()
		for boid in following:
			
			var desiredSeparation = position - boid.position
			if desiredSeparation.length() < boidSize * 1.5:
				separation += desiredSeparation
			
			alignment += boid.vel
			
			cohesion += boid.position - position
			
		alignment /= numBirds
		cohesion /= numBirds
	
	vel += separation + alignment + cohesion
	
	vel = attack(vel)
	
	#vel = avoidance(vel)
	
	vel += landBias(delta)
	
	vel = vel.normalized()

	
	
	var newFacing : float = min(
		lerp_angle(global_rotation, Vector2.ZERO.angle_to_point(vel), 1),
		PI / 2)
	
	if abs(newFacing - rotation) < PI / 6:
		speed = min(maxSpeed, speed * 1.1)
	elif abs(newFacing - rotation) >= PI / 3:
		speed = max(minSpeed, speed * 0.8)
	
	rotation = newFacing
	
	vel = Vector2.from_angle(rotation)
	
	position += vel * speed * delta
	wrapAround()

func _on_field_of_view_area_entered(area):
	if area != self and area.is_in_group("enemyBoid"):
		following.append(area)

func _on_field_of_view_area_exited(area):
	if area != self and area.is_in_group("enemyBoid"):
		following.erase(area)

func wrapAround():
	if position.x < 0:
		position.x = screensize.x
	if position.y < 0:
		position.y = screensize.y
	if position.x > screensize.x:
		position.x = 0
	if position.y > screensize.y:
		position.y = 0

func avoidance(currentVel : Vector2) -> Vector2:
	var newVel = Vector2.ZERO
	for ray in raycasts:
		if ray.is_colliding():
			var angle = Vector2.ONE.rotated(rotation).angle_to_point(ray.get_collision_point())
			var repulse = 0
			if goodBoid:
				print(angle)
	if newVel:
		return newVel
	return currentVel

func attack(currentVel : Vector2) -> Vector2:
	return currentVel

func landBias(delta : float) -> Vector2:
	if goodBoid: print(timeAtSea)
	if onLand:
		timeAtSea = 0
		return Vector2.ZERO
	
	timeAtSea += delta
	var nearestIsland = islands[0]
	
	for center in islands:
		if position.distance_to(center) < position.distance_to(nearestIsland):
			nearestIsland = center
	
	return (nearestIsland - position) * timeAtSea

func _on_area_exited(area):
	if area.is_in_group("island"):
		onLand = false

func _on_area_entered(area):
	if area.is_in_group("island"):
		onLand = true
