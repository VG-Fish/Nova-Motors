extends VBoxContainer


signal close(type)


func _on_button_button_down() -> void:
	close.emit("close")
