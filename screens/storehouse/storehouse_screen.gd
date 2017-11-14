extends "../abstract_screen.gd"


func _ready():
	populate_unities()
	
func _execute_event(event):
	print(event)
	
func populate_unities():
	var company = player.get_node("Company/Unities/PanelContainer/ScrollingContainer/List")
	for c in company.get_children():
		if c.is_in_group("gatherer"):
			get_node("Storehouse/Gatherer").show()
		elif c.is_in_group("mechanic"):
			get_node("Storehouse/Mechanic").show()
		elif c.is_in_group("plumber"):
			get_node("Storehouse/Plumber").show()
		elif c.is_in_group("specialist"):
			get_node("Storehouse/SoilSpecialist").show()
		elif c.is_in_group("engineer"):
			get_node("Storehouse/BotanicEngineer").show()
		elif c.is_in_group("tillage"):
			get_node("Storehouse/Tillage").show()
		elif c.is_in_group("truck"):
			get_node("Storehouse/Truck").show()
		elif c.is_in_group("harvester"):
			get_node("Storehouse/Harvester").show()
		else:
			for n in get_node("Storehouse").get_children():
				n.hide()