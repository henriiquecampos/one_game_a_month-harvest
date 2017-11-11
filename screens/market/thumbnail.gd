extends TextureButton

export (float) var price = 100
export (float) var monthly_cost = 400
export (String, MULTILINE) var description = "Insert Description"
export (int, "Worker", "Machine") var type = 0
export (float) var production = 10
export (String) var name = "Thumbnail"
export (int, "BUYING", "SELLING") var trade_type = 0

signal thumbnail_released(object, trade)
func _ready():
	if type == 0:
		get_node("Description").set_text("Type: %s \nWage: %s \nProduction: %s/h"%["Worker", monthly_cost, production])
	else:
		get_node("Description").set_text("Type: %s \nPrice: %s \nProduction: %s/h"%["Machinery", price, production])
		
	connect("thumbnail_released", get_parent(), "_on_thumbnail_released")
	get_node("Info").connect("released", get_parent(), "_on_info_released", [self])

func _on_released():
	emit_signal("thumbnail_released", self, trade_type)