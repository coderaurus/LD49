extends AudioStreamPlayer

var stored_volume = -5

func _on_SoundSlider_value_changed(value):
	volume_db = value;
	stored_volume = value


func _on_SoundToggle_pressed():
	if volume_db > -50:
		volume_db = -50
	else:
		volume_db = stored_volume
