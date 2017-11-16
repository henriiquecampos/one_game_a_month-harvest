extends "../abstract_screen.gd"

export (String, MULTILINE) var layoff
export (String, FILE, "*.tscn") var inspection
export (String, FILE, "*.tscn") var strike
func _ready():
	populate_unities()
	
func _execute_event(event):
	var s = null
	if event == EVENT_1:
		pass
	elif event == EVENT_2:
		get_node("Storehouse/Event/Inspection").show()
		s = load(inspection).instance()
	elif event == EVENT_3:
		s = load(strike).instance()
	add_child(s)
	get_node("Verify").connect("released",self, "_verify_released", [s])
	
func populate_unities():
	var company = player.get_node("Company/Unities/PanelContainer/ScrollingContainer/List")
	for c in company.get_children():
		if c.is_in_group("gatherer"):
			get_node("Storehouse/Gatherer").show()
			get_node("Storehouse/Gatherer/Label").set_text(str(get_tree().get_nodes_in_group("gatherer").size()))
		elif c.is_in_group("mechanic"):
			get_node("Storehouse/Mechanic").show()
			get_node("Storehouse/Mechanic/Label").set_text(str(get_tree().get_nodes_in_group("mechanic").size()))
		elif c.is_in_group("plumber"):
			get_node("Storehouse/Plumber").show()
			get_node("Storehouse/Plumber/Label").set_text(str(get_tree().get_nodes_in_group("plumber").size()))
		elif c.is_in_group("specialist"):
			get_node("Storehouse/SoilSpecialist").show()
			get_node("Storehouse/SoilSpecialist/Label").set_text(str(get_tree().get_nodes_in_group("specialist").size()))
		elif c.is_in_group("engineer"):
			get_node("Storehouse/BotanicEngineer").show()
			get_node("Storehouse/BotanicEngineer/Label").set_text(str(get_tree().get_nodes_in_group("engineer").size()))
		elif c.is_in_group("tillage"):
			get_node("Storehouse/Tillage").show()
			get_node("Storehouse/Tillage/Label").set_text("Tillages: " + str(get_tree().get_nodes_in_group("tillage").size()))
		elif c.is_in_group("truck"):
			get_node("Storehouse/Truck").show()
			get_node("Storehouse/Truck/Label").set_text(str(get_tree().get_nodes_in_group("truck").size()))
		elif c.is_in_group("harvester"):
			get_node("Storehouse/Harvester").show()
			get_node("Storehouse/Harvester/Label").set_text(str(get_tree().get_nodes_in_group("harvester").size()))

func _verify_released(event):
	event.show()
