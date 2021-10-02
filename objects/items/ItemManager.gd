extends Node2D


export var unique_items = {}
export var common_items = {}


onready var uniques : Node2D = get_node("Uniques")
onready var commons : Node2D = get_node("Commons")

var rng = RandomNumberGenerator.new()


func _ready():
	yield(get_tree(), "idle_frame")
#	init()


func init():
	for i in commons.get_child_count():
		var child = commons.get_child(i)
		if rng.randf() > 0.5 and commons.get_child_count() > 50:
			child.queue_free()
		else: 
			var item = child.get_node("Item")
			var selectedItem = common_items[rng.randi_range(0, common_items.count())]
			
			item.set_values(selectedItem)
			pass
