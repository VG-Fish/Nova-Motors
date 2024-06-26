extends Window

@onready var background = get_tree().current_scene.get_child(0)

func _ready() -> void:
	visible = false
	$"Pause Menu".position = Vector2(0, 0)

func _process(_delta) -> void:
	if Input.is_action_just_pressed("pause"):
		do_pause_menu()

func do_pause_menu() -> void:
	if get_tree().current_scene:
		background = get_tree().current_scene.get_child(0)
	else:
		background = DayChange.get_child(0)
	
	background.modulate = Color(0, 0, 0, 1)
	
	if not Globals.paused:
		background.visible = true
		visible = true
	else:
		background.visible = false
		visible = false
	Globals.paused = !Globals.paused

func _on_save_pressed() -> void:
	SaveGame.save_game(Globals.current_game)

func _on_settings_pressed() -> void:
	get_tree().change_scene_to_file("res://ui/settings.tscn")
	do_pause_menu()

func _on_resume_pressed() -> void:
	do_pause_menu()

func _on_quit_pressed() -> void:
	get_tree().quit()
