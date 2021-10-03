extends AudioStreamPlayer

onready var button : TextureButton = get_tree().current_scene.get_node("UI/Menu/Sound/SoundToggle")
onready var slider : HSlider = get_tree().current_scene.get_node("UI/Menu/Sound/SoundSlider")
onready var onTex = preload("res://gfx/toggle_on.png")
onready var offTex = preload("res://gfx/toggle_off.png")

var stored_volume = -5


func _ready():
	stored_volume = volume_db	


func _on_SoundSlider_value_changed(value):
	if value > -50:
		stored_volume = value
	else:
		stored_volume = volume_db
	volume_db = value;
		
	if volume_db > -50:
		button.texture_normal = onTex
	else:
		button.texture_normal = offTex

func _on_SoundToggle_pressed():
	if volume_db > -50:
		slider.value = -50
		button.texture_normal = offTex
	else:
		slider.value = stored_volume
		button.texture_normal = onTex
