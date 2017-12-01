extends "../abstract_screen.gd"

export (String, FILE, "*.tscn") var layoff
export (String, FILE, "*.tscn") var inspection
export (String, FILE, "*.tscn") var strike
export (String, FILE, "*.tscn") var next_scene
func _ready():
	populate_unities()
	yield(get_node("Tween"), "tween_complete")
	if !player.already_played:
		get_node("Help/Control").show()
	else:
		get_node("Help").queue_free()
	yield(get_node("Help"), "exit_tree")
	player.get_node("Company/Unities").set_theme(get_theme())
	for i in player.get_node("Info").get_children():
		i.set_theme(get_theme())
	player.get_node("Company/Unities").show()
	var s = load("res://screens/storehouse/foreground.tscn").instance()
	add_child(s)
	get_node("Foreground/Star").set_pos(player.get_node("Company/Unities").get_pos())
	get_node("Foreground/Floater").set_pos(get_node("Finish").get_end())
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
	s.set_name("Event")
	
func populate_unities():
	pass

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
	get_node("Event").show()
