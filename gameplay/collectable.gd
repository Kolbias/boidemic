extends Area2D

@export var resource_value := 10

func _ready():
	add_to_group("food")
	#print($Sprite2D.texture.resource_path)
	match $Sprite2D.texture.resource_path:
		"res://assets/art/Fish.png":
			add_to_group("fish")
		"res://assets/art/Mouse.png":
			add_to_group("mouse")
		"res://assets/art/Worm.png":
			add_to_group("worm")

