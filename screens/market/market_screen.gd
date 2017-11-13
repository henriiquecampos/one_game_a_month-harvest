extends "../abstract_screen.gd"
const event_scene = preload("res://screens/market/event.tscn")
export (String, MULTILINE) var min_wage
export (String, MULTILINE) var machine_regulation
export (String, MULTILINE) var new_contract_law

func _ready():
	player.get_node("Selling").show()
	for b in get_tree().get_nodes_in_group("buying"):
		b.get_node("Button").connect("released", self, "buy_unit", [b])
	for c in get_tree().get_nodes_in_group("contracts"):
		c.connect("toggled", self, "sign_new_contract", [c])
	for s in get_tree().get_nodes_in_group("selling"):
		s.get_node("Button").connect("released", self, "sell_unit", [s])

func _execute_event(event):
	._execute_event(event)
	var ev = event_scene.instance()
	var description = ev.get_node("CenterContainer/Panel/MarginContainer/Description")
	add_child(ev)
	if event == EVENT_1:
		if ceil(government.minimum_wage) < 9999:
			government.minimum_wage = ceil(rand_range(government.minimum_wage, government.minimum_wage + 2000))
			description.set_text(min_wage%government.minimum_wage)
			for worker in get_node("Buying/PanelContainer/ScrollingContainer/List").get_children():
				if worker.type == 0 and worker.production < government.minimum_wage:
					worker.queue_free()
		else:
			_execute_event(event +1)
	elif event == EVENT_2:
		var tax = government.taxes["Machinery"] * 100
		machine_regulation = machine_regulation.format({"tax":tax})
		description.set_text(machine_regulation)
		for m in get_node("Buying/PanelContainer/ScrollingContainer/List").get_children():
			if m.type == 1:
				m.price += m.price * government.taxes["Machinery"]
	elif event == EVENT_3:
		new_contract_law = new_contract_law.format({"amount":government.minimum_demand})
		for c in get_node("ContractPanel/Panel/Contracts/ScrollContainer/VBoxContainer").get_children():
			if c.demand > government.minimum_demand:
				c.queue_free()
		description.set_text(new_contract_law)
	for t in get_tree().get_nodes_in_group("thumbnails"):
		t.update_description()
	
func buy_unit(unit):
	if (player.money - unit.price) >= 0:
		player.set_unities(unit, player.ADD)
		var u = unit.duplicate(false, 5)
		u.price *= 0.5
		u.add_to_group("selling")
		u.get_node("Button").connect("released", self, "sell_unit", [u])
		player.company.add_child(u)
		u.update_description()

func sell_unit(unit):
	player.set_unities(unit, player.REMOVE)
	unit.queue_free()
	
func sign_new_contract(signed, contract):
	if signed:
		player.set_contracts(player.get_contracts() + contract.demand)
	else:
		player.set_contracts(player.get_contracts() - contract.demand)
	print(player.get_contracts())