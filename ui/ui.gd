extends CanvasLayer

@onready var hp_label = $Control/TopLeftMargin/VBoxContainer/HPLabel
@onready var upgrade_panel = $Control/MarginContainer/MarginContainer/UpgradePanel
@onready var margin_container = $Control/MarginContainer/MarginContainer

var is_visible := false

func _ready():
	hide_window()

func _process(delta):
	hp_label.text = "HP: " + str(int(PlayerVariables.current_hp))
func display_window():
	upgrade_panel.show()
	var tween = create_tween()
	var fade_tween = create_tween()
	tween.tween_property(upgrade_panel, "global_position", Vector2(0,100), 0.5).as_relative().set_trans(Tween.TRANS_SPRING)
	fade_tween.tween_property(upgrade_panel, "modulate", Color(1,1,1,1), 0.5)

func hide_window():
	var tween = create_tween()
	var fade_tween = create_tween()
	tween.tween_property(upgrade_panel, "global_position", Vector2(0,-100), 0.5).as_relative().set_trans(Tween.TRANS_SPRING)
	fade_tween.tween_property(upgrade_panel, "modulate", Color(1,1,1,0), 0.2)
	await tween.finished
	upgrade_panel.hide()


func _on_upgrades_pressed():
	if is_visible:
		hide_window()
		is_visible = false
	else:
		display_window()
		is_visible = true
