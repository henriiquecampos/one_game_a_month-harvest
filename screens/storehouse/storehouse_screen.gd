extends "../abstract_screen.gd"

export (String, FILE, "*.tscn") var layoff
export (String, FILE, "*.tscn") var inspection
export (String, FILE, "*.tscn") var strike
export (String, FILE, "*.tscn") var next_scene
func _ready():
	populate_unities()
	
func _execute_event(event):
	var s = null
	if event == EVENT_1:
		if get_tree().get_nodes_in_group("worker").size() >= 1:
			s = load(layoff).instance()
		else:
			return
	elif event == EVENT_2:
		if get_tree().get_nodes_in_group("machines").size() >= 1:
			s = load(inspection).instance()
		else:
			return
	elif event == EVENT_3:
		if get_tree().get_nodes_in_group("worker").size() >= 1:
			s = load(strike).instance()
		else:
			return
	add_child(s)
	get_node("Verify").show()
	s.set_name("Event")
	
func populate_unities():
	var company = player.company
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

func _on_finish_released():
	if get_node("Event") != null:
		get_node("Event")._option_chosen(0)
	var t = get_node("Tween")
	player.get_node("Company/Unities").hide()
	player.get_node("Info/Button").hide()
	t.interpolate_property(self, "rect/pos", get_pos(), get_pos() - Vector2(1024,0), 0.5, t.TRANS_BACK, t.EASE_IN)
	t.start()
	yield(t, "tween_complete")
	get_tree().change_scene(next_scene)

func _on_verify_released():
	get_node("Verify").hide()
	get_node("Event").show()
