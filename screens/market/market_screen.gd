extends "../abstract_screen.gd"
const event_scene = preload("res://screens/market/event.tscn")
export (String, MULTILINE) var min_wage
export (String, MULTILINE) var machine_regulation
export (String, MULTILINE) var new_contract_law

func _execute_event(event):
	._execute_event(event)
	var ev = event_scene.instance()
	var description = ev.get_node("CenterContainer/Panel/MarginContainer/Description")
	add_child(ev)

	if event == EVENT_1:
		description.set_text(min_wage%3000)
		for worker in get_node("Buying/PanelContainer/ScrollingContainer/List").get_children():
			print(worker.get_name())
			if worker.type == 0 and  worker.production < 3000:
				worker.queue_free()
	elif event == EVENT_2:
		description.set_text(machine_regulation%str(25)+"%")
	elif event == EVENT_3:
		description.set_text(new_contract_law%str(50)+"%")