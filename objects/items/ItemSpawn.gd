extends Area2D

signal hit

export var is_unique = false

func _on_ItemSpawn_hit():
	get_tree().current_scene.emit_signal("item_destroyed")
	queue_free()


func _on_ItemSpawn_body_entered(body):
	if body.is_in_group("Player"):
		get_tree().current_scene.emit_signal("item_picked", $Item.item_name, $Item.item_value)
		queue_free()
