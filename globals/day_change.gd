extends Control

func play_animation() -> void:
	if SceneSwitcher.get_scene_shown() == "res://scenes/Levels/board.tscn":
		return
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	var tween: Tween = get_tree().create_tween()
	tween.tween_property($Panel, "modulate", Color(1, 1, 1, 1), 1.5)
	await tween.finished
	tween.stop()
	get_tree().get_processed_tweens()[0].play()
	tween.tween_property($Panel, "modulate", Color(0, 0, 0, 0), 1.5)
	SceneSwitcher.show_scene(SceneSwitcher.SCENE.OFFICE)
	await tween.finished
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
