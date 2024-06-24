extends Interactable


func _ready() -> void:
	$"Action Layout".add_child(actions)


func _process(_delta: float) -> void:
	if not has_action:
		$AnimationPlayer.stop()
	else:
		$AnimationPlayer.play("up_and_down")
		
	if Input.is_action_just_pressed("primary action") and mouse_in_area and has_action:
		SceneSwitcher.show_scene(SceneSwitcher.SCENE.COMPUTER)
