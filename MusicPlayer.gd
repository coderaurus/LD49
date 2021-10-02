extends AudioStreamPlayer

var stored_volume


func _on_MusicSlider_value_changed(value):
	volume_db = value
	stored_volume = value


func _on_MusicToggle_pressed():
	if volume_db > -50:
		volume_db = -50
	else:
		volume_db = stored_volume
