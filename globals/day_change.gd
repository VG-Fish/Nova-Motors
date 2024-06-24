extends Control


func play_animation() -> void:
	var tween: Tween = get_tree().create_tween()
	tween.tween_property($Panel, "modulate", Color(1, 1, 1, 1), 1.5)
	tween.tween_property($Panel, "modulate", Color(0, 0, 0, 0), 1.5)
