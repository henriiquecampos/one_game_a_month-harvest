extends Node

export (float) var price = 100.0
export (float) var monthly_cost = 300.0
export (float) var production = 2000.0
export (int, "WORKER", "MACHINE") var type = 0
export (String) var name
export (String, MULTILINE) var description

func _ready():
	var b = get_node("Button")
	b.set_modulate(Color(1.0,1.0,1.0,1.0))
	b.connect("button_down", b, "set_modulate", [Color(0.5,0.5,0.5,1.0)])
	b.connect("button_up", b, "set_modulate", [Color(1.3,1.3,1.3,1.3)])
	b.connect("mouse_enter", b, "set_modulate", [Color(1.3,1.3,1.3,1.0)])
	b.connect("mouse_exit", b, "set_modulate", [Color(1.0,1.0,1.0,1.0)])
func update_description():
	var d = description
	if type == 0:
		d = description.format({"name":name, "wage":monthly_cost, "production":production, "type":"Worker"})
	elif type == 1:
		d = description.format({"name":name, "price":price, "monthly":monthly_cost, "production":production, "type":"Machine"})
	get_node("Description").set_text(d)