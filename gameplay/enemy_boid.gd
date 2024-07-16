extends Area2D
class_name Enemy_Boid

var islands := PlayerVariables.islands

var following := []
var flock := []
var player
var minFlock = PlayerVariables.min_flock

var vel := Vector2.ZERO
var lastNeighborCount := 10

var speed := 15.0
const minSpeed := 15.0
const maxSpeed := 75.0

var onLand : bool = false
var timeAtSea : float = 0
var stance = stanceState.WANDERING
enum stanceState {
	ATTACKING,
	FLEEING,
	WANDERING
}

var goodBoid = false

@onready var screensize := get_viewport_rect().size
@onready var boidSize : float = $BodyCollision.shape.radius

func _ready():
	var startRotation := randf_range(0, TAU)
	global_rotation = startRotation
	
	vel = Vector2.from_angle(rotation)
	
	$BirdSprite.set_frame(randi_range(0,7))

func _physics_process(delta):
	if goodBoid:
		print(stance)
	
	match stance:
		stanceState.ATTACKING:
			modulate = Color(1, 0, 0, 1)
		stanceState.FLEEING:
			modulate = Color(0, 0, 1, 1)
		_:
			modulate = Color(1, 1, 1, 1)
	
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
	
	if player:
		vel = attack(vel)
	
	var newFacing = lerp_angle(global_rotation, Vector2.ZERO.angle_to_point(vel), 1)
	
	if abs(newFacing - rotation) < PI / 6:
		speed = min(maxSpeed, speed * 1.1)
	elif abs(newFacing - rotation) >= PI / 3:
		speed = max(minSpeed, speed * 0.8)
	
	rotation = newFacing
	
	vel = Vector2.from_angle(rotation).normalized()
	
	position += vel * speed * delta

func _on_field_of_view_area_entered(area):
	if area != self and area.is_in_group("enemyBoid"):
		following.append(area)

func _on_field_of_view_area_exited(area):
	if area != self and area.is_in_group("enemyBoid"):
		following.erase(area)

func attack(currentVel : Vector2) -> Vector2:
	if stance == stanceState.WANDERING: return currentVel
	
	var vector : Vector2 = (player.position - position) * 50
	if stance == stanceState.ATTACKING:
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

func _on_flock_area_entered(area):
	if area != self and area.is_in_group("enemyBoid"):
		flock.append(area)

func _on_flock_area_exited(area):
	if area != self and area.is_in_group("enemyBoid"):
		flock.erase(area)

func _on_field_of_view_body_entered(body):
	if body.is_in_group("player"):
		print("see!")
		player = body
		if flock.size() > minFlock:
			stance = stanceState.ATTACKING
		else:
			stance = stanceState.FLEEING


func _on_flock_body_exited(body):
	if body.is_in_group("player"):
		player = null
		stance = stanceState.WANDERING
