extends Control

func _ready() -> void:
	visible = false

func win() -> void:
	SceneSwitcher.show_scene(SceneSwitcher.SCENE.NONE)
	get_tree().current_scene.visible = false
	$PanelContainer/VBoxContainer/Info.text = "Congrats! You've won! Your grade will be displayed on the local leaderboard. Feel free to start a new game to better your score!"
	visible = true

func lose() -> void:
	SceneSwitcher.show_scene(SceneSwitcher.SCENE.NONE)
	get_tree().current_scene.visible = false
	$PanelContainer/VBoxContainer/Info.text = "Unfortunately, you've lost. However, you can start a new game for a chance at winning!"
	visible = true

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/Menus/main_menu.tscn")
	visible = false
