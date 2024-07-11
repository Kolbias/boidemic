extends Area2D

@export var resource_value := 10

func _on_body_entered(body):
	if body.has_method("collect"):
		body.collect(resource_value)
		queue_free()
