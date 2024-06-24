extends Node2D
class_name door


var mouse_in_area: bool = false
var other_level: SceneSwitcher.SCENE
var player_nearby: bool = false


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("primary action") and mouse_in_area and player_nearby:
		SceneSwitcher.show_scene(other_level)
		mouse_in_area = false
		

func _on_area_2d_mouse_entered() -> void:
	mouse_in_area = true
	

func _on_area_2d_mouse_exited() -> void:
	mouse_in_area = true


func save() -> Dictionary:
	return {
		"path": scene_file_path,
		"IGNORE": true
	}


func _on_area_2d_2_body_entered(_body):
	player_nearby = true


func _on_area_2d_2_body_exited(_body):
	player_nearby = false
