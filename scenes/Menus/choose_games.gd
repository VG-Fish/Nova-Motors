extends Control

@onready var create_game_scene: PackedScene = preload("res://scenes/Menus/create_game.tscn")
@onready var new_game_scene: PackedScene = preload("res://scenes/Menus/new_game.tscn")

func _ready():
	SaveGame.load_track_of_games()

func _on_game_1_pressed() -> void:
	Globals.current_game = 0
	if !TrackOfGames.has_game[0]:
		TrackOfGames.has_game[0] = true
		get_tree().change_scene_to_packed(new_game_scene)
	else:
		SaveGame.load_game(0)
		# NOTE: TO ensure that we can always come back to this scene.
		get_parent().remove_child(self)
		# NOTE: TO ensure that we can always come back to this scene.
		get_parent().remove_child(self)
		SceneSwitcher.show_scene(SceneSwitcher.SCENE.OFFICE)
	SaveGame.save_track_of_games()

func _on_game_2_pressed() -> void:
	Globals.current_game = 1
	if !TrackOfGames.has_game[1]:
		TrackOfGames.has_game[1] = true
		get_tree().change_scene_to_packed(new_game_scene)
	else:
		SaveGame.load_game(1)
		get_parent().remove_child(self)
		get_parent().remove_child(self)
		SceneSwitcher.show_scene(SceneSwitcher.SCENE.OFFICE)
	SaveGame.save_track_of_games()

func _on_game_3_pressed() -> void:
	Globals.current_game = 2
	if !TrackOfGames.has_game[2]:
		TrackOfGames.has_game[2] = true
		get_tree().change_scene_to_packed(new_game_scene)
	else:
		SaveGame.load_game(2)
		get_parent().remove_child(self)
		get_parent().remove_child(self)
		SceneSwitcher.show_scene(SceneSwitcher.SCENE.OFFICE)
	SaveGame.save_track_of_games()

func _on_create_game_pressed() -> void:
	get_tree().change_scene_to_packed(create_game_scene)

func _on_button_pressed():
	get_tree().change_scene_to_file("res://scenes/Menus/main_menu.tscn")
