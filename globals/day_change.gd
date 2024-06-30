extends Control

#func _ready():
	#play_animation()

func play_animation() -> void:
	if SceneSwitcher.get_scene_shown() == "res://scenes/Levels/board.tscn":
		return
	
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	var tween: Tween = get_tree().create_tween()
	UI.visible = false
	$Panel.visible = true
	tween.tween_property($Panel, "modulate", Color.BLACK, 1.5)
	await tween.finished
	tween.stop()
	
	get_tree().get_processed_tweens()[0].play()
	tween.tween_property($Panel, "modulate", Color.WHITE, 1.5)
	SceneSwitcher.show_scene(SceneSwitcher.SCENE.OFFICE)
	await tween.finished
	UI.visible = true
	$Panel.visible = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
