extends TextureButton



func _on_toggle():
	if get_tree().current_scene.get_node("SoundPlayer").volume_db > -50:
		modulate = Color(0.5, 0.5, 0.5, 1)
	else:
		modulate = Color(1, 1, 1, 1)
