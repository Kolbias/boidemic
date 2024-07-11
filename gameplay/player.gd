extends CharacterBody2D

# Placeholder Mouse Movement
func _process(delta):
	look_at(get_global_mouse_position())

func _physics_process(delta):
	var vel : Vector2 = get_global_mouse_position() - global_position
	velocity = vel
	move_and_slide()


func collect(item_value):
	PlayerVariables.resource_amount += item_value
