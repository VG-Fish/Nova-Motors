extends Control

@onready var office_scene: PackedScene = preload("res://scenes/Levels/office.tscn")
var modes: Array[String] = ["easy", "medium", "hard"]

func _on_create_pressed() -> void:
	Globals.amount_of_actions = $"Options/Amount of Actions/HSlider".value
	Globals.mode = modes[$Options/Mode/OptionButton.selected]
	Globals.DAYS_THRESHOLD = $"Options/Days Threshold/SpinBox".value
	Globals.GRADE_THRESHOLD = $"Options/Grade Threshold/SpinBox".value
	# Stats
	Globals.stats["profit"] = $Options/Stats/Profit/SpinBox.value
	Globals.stats["public_relations"] = $"Options/Stats/Public Relations/SpinBox".value
	Globals.stats["employee_friendliness"] = $"Options/Stats/Employee Friendliness/SpinBox".value
	Globals.stats["product_quality"] = $"Options/Stats/Product Quality/SpinBox".value
	Globals.stats["environment_indicators"] = $"Options/Stats/Environment Indicators/SpinBox".value
	
	SaveGame.save_game(Globals.current_game)
	SceneSwitcher.show_scene(SceneSwitcher.SCENE.OFFICE)
	get_parent().remove_child(self)

func _on_button_pressed():
	get_tree().change_scene_to_file("res://scenes/Menus/main_menu.tscn")
