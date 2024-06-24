extends Node


enum SCENE {OFFICE = 0, TUTORIAL = 1, BOARD = 2, FACTORY = 3, COMPUTER = 4, MENU = 5, NONE = 6}
@onready var scenes: Array[Node] = [
	preload("res://scenes/Levels/office.tscn").instantiate(),
	preload("res://scenes/Levels/tutorial.tscn").instantiate(),
	preload("res://scenes/Levels/board.tscn").instantiate(),
	preload("res://scenes/Levels/factory.tscn").instantiate(),
	preload("res://scenes/inside_scenes/computer.tscn").instantiate(),
	preload("res://scenes/Menus/main_menu.tscn").instantiate(),
]
var current_scene: SCENE = SCENE.MENU

func _ready():
	for scene in scenes:
		if scene.name != "Main Menu":
			get_tree().root.add_child.call_deferred(scene)
	show_scene(SCENE.MENU)

func show_scene(scene: SCENE) -> void:
	if scene == SCENE.NONE:
		for s in scenes:
			s.visible = false
		return
		
	scenes[scene].visible = true
	for s in range(len(scenes)):
		if s != scene:
			scenes[s].hide()
	
	if scene == SCENE.BOARD:
		scenes[scene].add_dialogue()
		scenes[scene].add_dialogue()
	
	if scene not in [SCENE.MENU, SCENE.COMPUTER, SCENE.BOARD]:
		UI.visible = true
	else:
		UI.visible = false

func get_scene_shown() -> String:
	for s in scenes:
		if s.visible:
			return s.scene_file_path
	return get_tree().current_scene.scene_file_path
