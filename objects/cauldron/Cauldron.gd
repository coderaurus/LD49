extends Sprite

export var droplet = preload("res://objects/cauldron/Droplet.tscn")


func _ready():
	yield(get_tree(), "idle_frame")
	start()


func start():
	$LaunchTimer.start()


func _on_LaunchTimer_timeout():
	var dropletInstance = droplet.instance()
	owner.add_child(dropletInstance)
	dropletInstance.global_position = global_position + Vector2.UP
	dropletInstance.launch()
