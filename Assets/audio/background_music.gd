extends Node2D

func _process(_delta):
	if SceneSwitcher.get_scene_shown() and not SceneSwitcher.get_scene_shown().contains("res://scenes/Menus/"):
		$AudioStreamPlayer2D.stop()
