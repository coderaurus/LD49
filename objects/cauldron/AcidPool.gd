extends Area2D


func _ready():
	$AnimationPlayer.play("init")
	yield($AnimationPlayer, "animation_finished")
	$AnimationPlayer.play("idle")


func _on_hit(body):
	if body.is_in_group("Player") or body.is_in_group("Item"):
		body.emit_signal("hit")


func _on_body_entered(body):
	_on_hit(body)


func _on_area_entered(_area_id, area, _area_shape, _local_shape):
	_on_hit(area)


func despawn():
	$AnimationPlayer.play("dissolve")
	yield($AnimationPlayer, "animation_finished")
	queue_free()
