extends CanvasLayer


func _process(delta):
	if Input.is_action_just_pressed("ui_cancel") and !get_tree().paused:
		if get_tree().paused:
			$Menu.hide()
			$How2Play.hide()
			get_tree().paused = false
		else:
			$Menu.show()
			$Menu/PlayButton.grab_focus()
			get_tree().paused = true
		


func _on_PlayButton_pressed():
	$Menu.hide()
	$How2Play.hide()
	
	if owner.game_started:
		get_tree().current_scene.resume_game()
	else:
		get_tree().current_scene.start_game()
		$Menu/PlayButton.text = "Resume"
	


func _on_guide_toggle(button_pressed):
	if button_pressed and !$How2Play.visible:
		$How2Play.show()
	elif !button_pressed and $How2Play.visible:
		$How2Play.hide()
