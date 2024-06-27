extends Control

func _on_easy_mode_pressed() -> void:
	Globals.mode = "easy"
	get_parent().remove_child(self)
	SceneSwitcher.show_scene(SceneSwitcher.SCENE.OFFICE)
	SaveGame.save_game(Globals.current_game)
	Globals.local_multiplayer = $"Mode Options/Multiplayer".button_pressed

func _on_medium_mode_pressed() -> void:
	Globals.mode = "medium"
	get_parent().remove_child(self)
	SceneSwitcher.show_scene(SceneSwitcher.SCENE.OFFICE)
	SaveGame.save_game(Globals.current_game)
	Globals.local_multiplayer = $"Mode Options/Multiplayer".button_pressed

func _on_hard_mode_pressed() -> void:
	Globals.mode = "hard"
	get_parent().remove_child(self)
	SceneSwitcher.show_scene(SceneSwitcher.SCENE.OFFICE)
	SaveGame.save_game(Globals.current_game)
	Globals.local_multiplayer = $"Mode Options/Multiplayer".button_pressed

func _on_button_pressed():
	get_tree().change_scene_to_file("res://scenes/Menus/main_menu.tscn")
