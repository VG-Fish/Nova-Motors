extends CanvasLayer


func _process(_delta: float) -> void:
	# For timer
	$Timer/PanelContainer/HBoxContainer/Label.text = str(Globals.amount_of_actions)
	
	# For stats
	$Stats/Panel/VBoxContainer/Profit/Label.text = str(snapped(Globals.stats["profit"], 0.01))
	$"Stats/Panel/VBoxContainer/Environment Indicators/Label".text = str(snapped(Globals.stats["environment_indicators"], 0.01))
	$"Stats/Panel/VBoxContainer/Employee Friendliness/Label".text = str(snapped(Globals.stats["employee_friendliness"], 0.01))
	$"Stats/Panel/VBoxContainer/Public Relations/Label".text = str(snapped(Globals.stats["public_relations"], 0.01))
	$"Stats/Panel/VBoxContainer/Product Quality/Label".text = str(snapped(Globals.stats["product_quality"], 0.01))


func _on_button_pressed() -> void:
	$"Optional Continue Scene".visible = false


func _on_button_2_pressed() -> void:
	get_tree().change_scene_to_file("res://ui/local_leaderboard.tscn")
	visible = false
