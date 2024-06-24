extends Node2D
class_name Level

# Miscellaneous
var days_passed: int = 0

# Pause Menu Related
@onready var pause_menu = PauseMenu


func _ready() -> void:
	Globals.connect("day_changed", check_board_summon)
	$Player.connect("show_interactable_actions", show_interactable_actions)


func show_interactable_actions(area: Area2D) -> void:
	for interactable_object in $Interactables.get_children():
		if interactable_object.get_child(interactable_object.get_child_count() - 1) == area:
			interactable_object.actions.visible = true


func check_board_summon() -> void:
	days_passed += 1
	if days_passed >= 7:
		SceneSwitcher.show_scene(SceneSwitcher.SCENE.BOARD)


func save() -> Dictionary:
	var save_data: Dictionary = {
		"parent": get_parent().get_path(),
		"path": scene_file_path,
		"days_passed": days_passed,
		"$Player": {
			"path": $Player.scene_file_path,
			"x": $Player.global_position.x,
			"y": $Player.global_position.y
		},
		"interactables": save_interactable_data()
	}
	return save_data
	

func save_interactable_data() -> Dictionary:
	var interactable_data: Dictionary = {}
	for i in range($Interactables.get_child_count()):
		interactable_data[$Interactables.get_child(i).name] = $Interactables.get_child(i).save()
	return interactable_data
