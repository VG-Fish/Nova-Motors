extends Control

@onready var tutorial_scene: PackedScene = preload("res://scenes/Levels/tutorial.tscn")
@onready var choose_game_scene: PackedScene = preload("res://scenes/Menus/choose_games.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()

func _on_start_pressed() -> void:
	SceneSwitcher.show_scene(SceneSwitcher.SCENE.NONE)
	get_tree().change_scene_to_packed(choose_game_scene)

func _on_tutorial_pressed() -> void:
	SceneSwitcher.show_scene(SceneSwitcher.SCENE.TUTORIAL)

func _on_leaderboard_pressed():
	get_tree().change_scene_to_file("res://ui/local_leaderboard.tscn")
