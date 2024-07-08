extends Area2D

var following := []
var vel := Vector2.ZERO
@onready var screensize := get_viewport_rect().size
var speed := 150.0
var goodBoid = false

func _ready():
	global_position = Vector2(
		randf_range(0, screensize.x),
		randf_range(0, screensize.y)
	)
	
	var startRotation := randf_range(0, TAU)
	global_rotation = startRotation
	
	vel = Vector2.from_angle(rotation)

func _physics_process(delta):
	var separation := position
	var alignment := vel
	var cohesion := position
	var avoidance := Vector2.ZERO
	var attack := Vector2.ZERO
	
	if following:
		var numBirds := following.size()
		for boid in following:
			
			var desiredSeparation = position - boid.position
			if desiredSeparation.length() < 100:
				separation += desiredSeparation
			
			alignment += boid.vel
			
			cohesion += boid.position
			
		alignment /= numBirds
		cohesion /= numBirds
	
	vel += separation + alignment + cohesion + avoidance + attack

	vel = vel.normalized()
	rotation = lerp_angle(global_rotation, vel.angle_to_point(Vector2.ZERO), 1) + PI
	
	position += vel * speed * delta

func _on_field_of_view_area_entered(area):
	if area != self and area.is_in_group("enemyBoid"):
		following.append(area)

func _on_field_of_view_area_exited(area):
	if area != self and area.is_in_group("enemyBoid"):
		following.erase(area)
