extends AudioStreamPlayer

export var sounds : Dictionary = {}


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
	play_sound("droplet")

func _on_SoundToggle_pressed():
	if volume_db > -50:
		slider.value = -50
		button.texture_normal = offTex
	else:
		slider.value = stored_volume
		button.texture_normal = onTex


func play_sound(sfx : String, volume = -60):
	if sounds.has(sfx):
		stream = sounds.get(sfx)
		if volume > -60:
			play(0.0, volume)
		else:
			play()


func play( from_position=0.0, volume = -60 ):
	var asp = self.duplicate(DUPLICATE_USE_INSTANCING)
	get_parent().add_child(asp)
	asp.mix_target = mix_target
	if volume > -60:
		asp.volume_db = volume
	else:
		asp.volume_db = volume_db
	asp.stream = stream
	asp.play()
	yield(asp, "finished")
	asp.queue_free()
