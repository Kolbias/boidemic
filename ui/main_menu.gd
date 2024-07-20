extends Control

func _process(delta):
	$MainBoid.position += Vector2(1,-1)
	if $MainBoid.position.y < -400:
		$MainBoid.position = Vector2(-56, 760)
func _on_play_button_pressed():
	get_tree().change_scene_to_file("res://main.tscn")
