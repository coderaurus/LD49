extends Area2D

var checkVisibility = false


func _ready():
	$AnimationPlayer.play("init")
	yield($AnimationPlayer, "animation_finished")
	$AnimationPlayer.play("idle")
	checkVisibility = true

func _process(_delta):
	if !$VisibilityNotifier2D.is_on_screen() and checkVisibility:
		despawn()


func _on_hit(body):
	if body.is_in_group("Player") or (body.is_in_group("Item") and !body.is_unique):
		body.emit_signal("hit")


func _on_body_entered(body):
	_on_hit(body)


func _on_area_entered(_area_id, area, _area_shape, _local_shape):
	if area.is_in_group("Exit"):
		$DespawnTimer.start(0.1)
		$AnimationPlayer.playback_speed = 2
	else:
		_on_hit(area)


func despawn():
	$AnimationPlayer.play("dissolve")
	yield($AnimationPlayer, "animation_finished")
	queue_free()
