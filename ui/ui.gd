extends CanvasLayer

@onready var resource_label = $Control/MarginContainer/VBoxContainer/Label

func _process(delta):
	resource_label.text = "Resources: " + str(PlayerVariables.resource_amount)
