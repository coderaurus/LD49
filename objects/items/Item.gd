extends Sprite

export var item_icon : Texture

var item_name : String = "Item"
var item_value : int = 100


func set_values(values : Array):
	item_icon = values[0]
	item_icon = values[1]
	
	if values[2]:
		item_icon = values[2]
		texture = item_icon
