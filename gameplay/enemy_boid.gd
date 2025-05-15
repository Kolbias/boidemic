extends Area2D
class_name Enemy_Boid

var islands := PlayerVariables.islands

var flock_set := { }

var player
var minFlock = PlayerVariables.min_flock

var vel := Vector2.ZERO

var speed := 15.0
const minSpeed := 15.0
const maxSpeed := 75.0

var onLand : bool = false
var timeAtSea : float = 0

var resource_value := 5

var stance = stance_state.WANDERING
enum stance_state {
	ATTACKING,
	FLEEING,
	WANDERING
}

var spawn: Node

@onready var screensize := get_viewport_rect().size
var boidSize : float = 8

func _ready():
	var startRotation := randf_range(0, TAU)
	global_rotation = startRotation
	vel = Vector2.from_angle(rotation)
	$BirdSprite.set_frame(randi_range(0,7))

func _physics_process(delta):
	var steering = calculate_steering()
	if steering != Vector2.ZERO:
		vel += steering
	
	if !onLand:
		vel += landBias(delta)
	
	vel = vel.normalized()
	
	if player:
		vel = attack(vel)
	
	var new_facing = lerp_angle(global_rotation, Vector2.ZERO.angle_to_point(vel), 1)
	
	if abs(new_facing - rotation) < PI / 6:
		speed = min(maxSpeed, speed * 1.1)
	elif abs(new_facing - rotation) >= PI / 3:
		speed = max(minSpeed, speed * 0.8)
	
	rotation = new_facing
	
	vel = Vector2.from_angle(rotation).normalized()
	
	global_position += vel * speed * delta

func calculate_steering() -> Vector2:
	if (spawn):
		var separation := Vector2.ZERO
		var alignment := Vector2.ZERO
		var cohesion_center := Vector2.ZERO
		var cohesion_final := Vector2.ZERO
		var valid_flock_size := 0
		
		var boids = spawn.get_boids()
		for boid in boids:
			if !is_instance_valid(boid) || boid == self:
				pass
			if !flock_set.has(boid.get_instance_id()) && in_fov(boid.global_position):
				flock_set[boid.get_instance_id()] = boid
			elif flock_set.has(boid.get_instance_id()) && global_position.distance_to(boid.global_position) > 75:
				flock_set.erase(boid.get_instance_id())
			
		for boid in flock_set.values():
			if !is_instance_valid(boid):
				continue
			
			var offset = global_position - boid.global_position
			if offset.length() < boidSize * 2:
				separation += offset.normalized() / offset.length()
			
			alignment += boid.vel
			cohesion_center += boid.global_position
			valid_flock_size += 1
		
		if valid_flock_size > 0:
			alignment /= valid_flock_size
			cohesion_center /= valid_flock_size
			cohesion_final = (cohesion_center - global_position).normalized() * 0.5
		else:
			cohesion_final = Vector2.ZERO
		return (separation * 1.5) + (alignment * 1.0) + (cohesion_final * 0.8)
	else:
		return Vector2.ZERO

func attack(currentVel : Vector2) -> Vector2:
	if stance == stance_state.WANDERING: return currentVel
	
	var vector : Vector2 = (player.global_position - global_position) * 50
	if stance == stance_state.ATTACKING:
		return currentVel + vector
	else:
		return currentVel - vector

func landBias(delta : float) -> Vector2:
	if islands.size() == 0: return Vector2.ZERO
	timeAtSea += delta
	var nearestIsland = islands[0]
	
	for center in islands:
		if global_position.distance_to(center) < global_position.distance_to(nearestIsland):
			nearestIsland = center
	
	return (nearestIsland - global_position).normalized() * timeAtSea / 10

func _on_area_exited(area):
	if area.is_in_group("island"):
		onLand = false

func _on_area_entered(area):
	if area.is_in_group("island"):
		onLand = true
		timeAtSea = 0

func _on_player_tracker_body_entered(body):
	if body.is_in_group("player"):
		player = body
		if flock_set.size() > minFlock:
			stance = stance_state.ATTACKING
		else:
			stance = stance_state.FLEEING

func _on_player_tracker_body_exited(body):
	if body.is_in_group("player"):
		player = null
		stance = stance_state.WANDERING

func in_fov(point: Vector2) -> bool:
	var dist = global_position.distance_to(point)
	
	if !is_zero_approx(dist) && dist < 72:
		if abs(global_position.angle_to(point) - rotation) < deg_to_rad(75):
			return true
			
	return false
