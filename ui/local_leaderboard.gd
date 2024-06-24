extends Control

@onready var leaderboard_text: Label = $PanelContainer/ScrollContainer/Label

func _ready():
	leaderboard_text.text += "\t\t Leaderboard\n"
	
	var leaderboard: Array = TrackOfGames.leaderboard
	leaderboard.sort_custom(sort_by_grade)

	for i in range(min(5, leaderboard.size())):
		leaderboard_text.text += "\t\t Game %d: %.2f\n" % [leaderboard[i][0],leaderboard[i][1]]

func sort_by_grade(a: Array, b: Array) -> Array:
	if a[1] < b[1]:
		return a
	return b

func _on_main_menu_button_pressed():
	get_tree().change_scene_to_file("res://scenes/Menus/main_menu.tscn")
