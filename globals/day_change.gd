extends CanvasLayer

func play_animation() -> void:
	if SceneSwitcher.get_scene_shown() == "res://scenes/Levels/board.tscn":
		return
		
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	var tween: Tween = get_tree().create_tween()
	UI.visible = false
	tween.tween_property($ColorRect, "modulate", Color(1, 1, 1, 1), 1.5)
	await tween.finished
	tween.stop()
	
	get_tree().get_processed_tweens()[0].play()
	tween.tween_property($ColorRect, "modulate", Color(0, 0, 0, 0), 1.5)
	SceneSwitcher.show_scene(SceneSwitcher.SCENE.OFFICE)
	# INFO: The line above will make the UI visible
	UI.visible = false
	await tween.finished
	UI.visible = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
