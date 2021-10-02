extends CanvasLayer


func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		if get_tree().paused:
			$Menu.hide()
			get_tree().paused = false
		else:
			$Menu.show()
			$Menu/PlayButton.grab_focus()
			get_tree().paused = true
		


func _on_PlayButton_pressed():
	$Menu.hide()
	
	if owner.game_started:
		get_tree().current_scene.resume_game()
	else:
		get_tree().current_scene.start_game()
		$Menu/PlayButton.text = "Resume"
	
