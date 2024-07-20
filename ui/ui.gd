extends CanvasLayer

@onready var hp_label = $Control/TopLeftMargin/VBoxContainer/HPLabel
@onready var upgrade_panel = $Control/MarginContainer/MarginContainer/UpgradePanel
@onready var margin_container = $Control/MarginContainer/MarginContainer
@onready var res_label = $Control/TopLeftMargin/VBoxContainer/ResourceLabel
@onready var blink_label = $Control/TopLeftMargin/VBoxContainer/BlinkLabel
@onready var hpcost_label = $Control/MarginContainer/MarginContainer/UpgradePanel/UpgradeHbox/VBoxUpgrade1/HpCostLabel
@onready var speedcost_label = $Control/MarginContainer/MarginContainer/UpgradePanel/UpgradeHbox/VBoxUpgrade2/SpeedCostLabel
@onready var blinkcountcost_label = $Control/MarginContainer/MarginContainer/UpgradePanel/UpgradeHbox/VBoxUpgrade3/BlinkCountCostLabel
@onready var blinktimecost_label = $Control/MarginContainer/MarginContainer/UpgradePanel/UpgradeHbox/VBoxUpgrade4/BlinkTimeCostLabel
@onready var flockcost_label = $Control/MarginContainer/MarginContainer/UpgradePanel/UpgradeHbox/VBoxUpgrade6/FlockCostLabel
@onready var foodcost_label = $Control/MarginContainer/MarginContainer/UpgradePanel/UpgradeHbox/VBoxUpgrade5/FoodCostLabel

var is_visible := false
var is_clickable := true
@onready var active = true

func _ready():
	PlayerVariables.connect("victory", _on_win)
	PlayerVariables.connect("dead", _on_died)
	$Control/MarginContainer/MarginContainer/UpgradePanel.hide()
	var sprite : Sprite2D = $Control/MarginContainer/MarginContainer/UpgradePanel/UpgradeHbox/VBoxUpgrade5/Panel/Sprite2D
	var textures = [
		"res://assets/art/upgrades/FishFoodUpgrade.png",
		"res://assets/art/upgrades/CrabFoodUpgrade.png",
		"res://assets/art/upgrades/MinFlockUpgrade.png"
	]
	if PlayerVariables.upgrade_levels["food_level"] < 4 && PlayerVariables.upgrade_levels["food_level"] > 0:
		sprite.texture = load(textures[PlayerVariables.upgrade_levels["food_level"] - 1])
	elif PlayerVariables.upgrade_levels["food_level"] == 4:
		$Control/MarginContainer/MarginContainer/UpgradePanel/UpgradeHbox/VBoxUpgrade5.hide()

func _process(delta):
	hp_label.text = "HP: " + str(int(PlayerVariables.current_hp))
	res_label.text = "Resources: " + str(PlayerVariables.resource_amount)
	blink_label.text = "Dodges: " + str(PlayerVariables.remaining_blinks)
	hpcost_label.text = str(PlayerVariables.upgrade_prices[0][0] + PlayerVariables.upgrade_prices[0][1])
	speedcost_label.text = str(PlayerVariables.upgrade_prices[1][0] + PlayerVariables.upgrade_prices[1][1])
	blinkcountcost_label.text = str(PlayerVariables.upgrade_prices[2][0] + PlayerVariables.upgrade_prices[2][1])
	blinktimecost_label.text = str(PlayerVariables.upgrade_prices[3][0] + PlayerVariables.upgrade_prices[3][1])
	flockcost_label.text = str(PlayerVariables.upgrade_prices[4][0] + PlayerVariables.upgrade_prices[4][1])
	foodcost_label.text = str(PlayerVariables.upgrade_prices[5][PlayerVariables.upgrade_levels["food_level"]])

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
	var sprite : Sprite2D = $Control/MarginContainer/MarginContainer/UpgradePanel/UpgradeHbox/VBoxUpgrade5/Panel/Sprite2D
	var textures = [
		"res://assets/art/upgrades/FishFoodUpgrade.png",
		"res://assets/art/upgrades/CrabFoodUpgrade.png",
		"res://assets/art/upgrades/MinFlockUpgrade.png"
	]
	if PlayerVariables.upgrade_levels[upgrade_name] >= 4: return
	var this_level = PlayerVariables.upgrade_levels[upgrade_name]
	if PlayerVariables.resource_amount >= \
	PlayerVariables.upgrade_prices[5][this_level]:
		PlayerVariables.resource_amount -= PlayerVariables.upgrade_prices[5][this_level]
		PlayerVariables.upgrade_levels[upgrade_name] += 1
		if PlayerVariables.upgrade_levels[upgrade_name] < 4:
			sprite.texture = load(textures[PlayerVariables.upgrade_levels[upgrade_name] - 1])
		else:
			$Control/MarginContainer/MarginContainer/UpgradePanel/UpgradeHbox/VBoxUpgrade5.hide()

func _on_reset_button_pressed():
	if active:
		active = false
		PlayerVariables.dead.emit()
	else:
		PlayerVariables.reset.emit()

func _on_died():
	$Control/CenterContainer/Label.show()

func _on_win():
	$Control/CenterContainer/Label.text = "You win!"
	$Control/CenterContainer/Label.show()
