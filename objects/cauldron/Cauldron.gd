extends StaticBody2D

export var droplet = preload("res://objects/cauldron/Droplet.tscn")
var player

var rng = RandomNumberGenerator.new()

func _ready():
	yield(get_tree(), "idle_frame")
	player = get_tree().current_scene.get_node("Player")
	$AnimationPlayer.play("idle")
	start()


func start():
	$LaunchTimer.start()

func _process(_delta):
	if player.global_position.y > global_position.y:
		z_index = player.z_index - 1
	else:
		z_index = player.z_index + 1


func _on_LaunchTimer_timeout():
	if rng.randf() > 0.3:
		add_droplet(2)
	else:
		add_droplet()
		
func add_droplet(amount : int = 1):
	for i in amount:
		var dropletInstance = droplet.instance()
		owner.add_child(dropletInstance)
		dropletInstance.global_position = global_position + Vector2.UP
		dropletInstance.launch()
