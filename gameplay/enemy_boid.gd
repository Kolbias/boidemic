extends Area2D
class_name Enemy_Boid

var islands := [Vector2.ZERO]

var following := []
var player

var vel := Vector2.ZERO
var lastNeighborCount := 10

var speed := 15.0
const minSpeed := 15.0
const maxSpeed := 75.0

var onLand : bool = false
var timeAtSea : float = 0

enum state {
	ATTACKING,
	FLEEING,
	WANDERING
}

var goodBoid = false
var data

@onready var screensize := get_viewport_rect().size
@onready var boidSize : float = $BodyCollision.shape.radius

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
			
			if desiredSeparation.length() < boidSize * 2:
				separation += desiredSeparation
			
			alignment += boid.vel
			
			cohesion += boid.position - position
			
		alignment /= numBirds
		cohesion /= numBirds
	
	vel += separation + alignment + cohesion
	
	if !onLand:
		vel += landBias(delta)
	
	vel = vel.normalized()
	
	vel = attack(vel)
	
	var newFacing = lerp_angle(global_rotation, Vector2.ZERO.angle_to_point(vel), 1)
	
	if abs(newFacing - rotation) < PI / 6:
		speed = min(maxSpeed, speed * 1.1)
	elif abs(newFacing - rotation) >= PI / 3:
		speed = max(minSpeed, speed * 0.8)
	
	rotation = newFacing
	
	vel = Vector2.from_angle(rotation).normalized()
	
	position += vel * speed * delta
	wrapAround()

func _on_field_of_view_area_entered(area):
	if area != self and area.is_in_group("enemyBoid"):
		following.append(area)
	elif area.is_in_group("player"):
		player = area
		if $Flock.get_overlapping_bodies() > 4:
			state.ATTACKING
		else:
			state.FLEEING

func _on_field_of_view_area_exited(area):
	if area != self and area.is_in_group("enemyBoid"):
		following.erase(area)
	elif area.is_in_group("player"):
		state.WANDERING

func wrapAround():
	if position.x < 0:
		position.x = screensize.x
	if position.y < 0:
		position.y = screensize.y
	if position.x > screensize.x:
		position.x = 0
	if position.y > screensize.y:
		position.y = 0

func attack(currentVel : Vector2) -> Vector2:
	if state.WANDERING: return currentVel
	
	var vector : Vector2 = (player.position - position) * 50
	if state.ATTACKING:
		return currentVel + vector
	else:
		return currentVel - vector

func landBias(delta : float) -> Vector2:
	if islands.size() == 0: return Vector2.ZERO
	timeAtSea += delta
	var nearestIsland = islands[0]
	
	for center in islands:
		if position.distance_to(center) < position.distance_to(nearestIsland):
			nearestIsland = center
	
	return (nearestIsland - position).normalized() * timeAtSea / 10

func _on_area_exited(area):
	if area.is_in_group("island"):
		onLand = false

func _on_area_entered(area):
	if area.is_in_group("island"):
		onLand = true
		timeAtSea = 0
