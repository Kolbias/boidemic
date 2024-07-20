extends Area2D

@export var resource_value := 2

func _ready():
	add_to_group("food")
	#print($Sprite2D.texture.resource_path)
	match $Sprite2D.texture.resource_path:
		"res://assets/art/Fish.png":
			add_to_group("fish")
			resource_value = 10
		"res://assets/art/Mouse.png":
			add_to_group("mouse")
			resource_value = 5
		"res://assets/art/Worm.png":
			add_to_group("worm")
		"res://assets/art/Crab.png":
			add_to_group("crab")
			resource_value = 15

