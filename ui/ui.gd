extends CanvasLayer

@onready var hp_label = $Control/TopLeftMargin/VBoxContainer/HPLabel
@onready var upgrade_panel = $Control/MarginContainer/MarginContainer/UpgradePanel
@onready var margin_container = $Control/MarginContainer/MarginContainer
@onready var res_label = $Control/TopLeftMargin/VBoxContainer/ResourceLabel

var is_visible := false
var is_clickable := true

func _ready():
	$Control/MarginContainer/MarginContainer/UpgradePanel.hide()
	#hide_window()

func _process(delta):
	hp_label.text = "HP: " + str(int(PlayerVariables.current_hp))
	res_label.text = "Resources: " + str(PlayerVariables.resource_amount)

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

func _on_upgrades_button_down():
	if is_visible:
		hide_window()
		is_visible = false
	
	else:
		display_window()
		is_visible = true


func _on_max_hp_button_pressed():
	var upgrade_name = "max_hp"
	var index = 0
	var this_level = PlayerVariables.upgrade_levels[upgrade_name]
	var cost = PlayerVariables.upgrade_prices[index][0] + PlayerVariables.upgrade_prices[index][1]
	if PlayerVariables.resource_amount >= cost:
		PlayerVariables.resource_amount -= cost
		var first = PlayerVariables.upgrade_prices[index][0]
		var second = PlayerVariables.upgrade_prices[index][1]
		var next = first + second
		PlayerVariables.upgrade_prices[index][0] = second
		PlayerVariables.upgrade_prices[index][1] = next
		PlayerVariables.upgrade_levels[upgrade_name] += 1

func _on_max_speed_button_pressed():
	var upgrade_name = "max_speed"
	var index = 1
	var this_level = PlayerVariables.upgrade_levels[upgrade_name]
	var cost = PlayerVariables.upgrade_prices[index][0] + PlayerVariables.upgrade_prices[index][1]
	if PlayerVariables.resource_amount >= cost:
		PlayerVariables.resource_amount -= cost
		var first = PlayerVariables.upgrade_prices[index][0]
		var second = PlayerVariables.upgrade_prices[index][1]
		var next = first + second
		PlayerVariables.upgrade_prices[index][0] = second
		PlayerVariables.upgrade_prices[index][1] = next
		PlayerVariables.upgrade_levels[upgrade_name] += 1

func _on_blink_count_button_pressed():
	var upgrade_name = "blink_count"
	var index = 2
	var this_level = PlayerVariables.upgrade_levels[upgrade_name]
	var cost = PlayerVariables.upgrade_prices[index][0] + PlayerVariables.upgrade_prices[index][1]
	if PlayerVariables.resource_amount >= cost:
		PlayerVariables.resource_amount -= cost
		var first = PlayerVariables.upgrade_prices[index][0]
		var second = PlayerVariables.upgrade_prices[index][1]
		var next = first + second
		PlayerVariables.upgrade_prices[index][0] = second
		PlayerVariables.upgrade_prices[index][1] = next
		PlayerVariables.upgrade_levels[upgrade_name] += 1

func _on_blink_time_button_pressed():
	var upgrade_name = "blink_time"
	var index = 3
	var this_level = PlayerVariables.upgrade_levels[upgrade_name]
	var cost = PlayerVariables.upgrade_prices[index][0] + PlayerVariables.upgrade_prices[index][1]
	if PlayerVariables.resource_amount >= cost:
		PlayerVariables.resource_amount -= cost
		var first = PlayerVariables.upgrade_prices[index][0]
		var second = PlayerVariables.upgrade_prices[index][1]
		var next = first + second
		PlayerVariables.upgrade_prices[index][0] = second
		PlayerVariables.upgrade_prices[index][1] = next
		PlayerVariables.upgrade_levels[upgrade_name] += 1

func _on_min_flock_button_pressed():
	var upgrade_name = "min_flock"
	var index = 4
	var this_level = PlayerVariables.upgrade_levels[upgrade_name]
	var cost = PlayerVariables.upgrade_prices[index][0] + PlayerVariables.upgrade_prices[index][1]
	if PlayerVariables.resource_amount >= cost:
		PlayerVariables.resource_amount -= cost
		var first = PlayerVariables.upgrade_prices[index][0]
		var second = PlayerVariables.upgrade_prices[index][1]
		var next = first + second
		PlayerVariables.upgrade_prices[index][0] = second
		PlayerVariables.upgrade_prices[index][1] = next
		PlayerVariables.upgrade_levels[upgrade_name] += 1

func _on_food_level_button_pressed():
	var upgrade_name = "food_level"
	if PlayerVariables.upgrade_levels[upgrade_name] >= 4: return
	var this_level = PlayerVariables.upgrade_levels[upgrade_name]
	if PlayerVariables.resource_amount >= \
	PlayerVariables.upgrade_prices[5][this_level]:
		PlayerVariables.resource_amount -= PlayerVariables.upgrade_prices[5][this_level]
		PlayerVariables.upgrade_levels[upgrade_name] += 1


func _on_reset_button_pressed():
	PlayerVariables.reset.emit()
