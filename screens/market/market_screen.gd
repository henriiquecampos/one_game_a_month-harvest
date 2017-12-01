extends "../abstract_screen.gd"
const event_scene = preload("res://screens/market/event.tscn")
export (String, MULTILINE) var min_wage
export (String, MULTILINE) var machine_regulation
export (String, MULTILINE) var new_contract_law
export (String, FILE, "*.tscn") var next_scene

func _ready():
	player.current_round += 1
	for b in get_tree().get_nodes_in_group("buying"):
		b.get_node("Button").connect("released", self, "buy_unit", [b])
	for c in get_tree().get_nodes_in_group("contracts"):
		c.connect("toggled", self, "sign_new_contract", [c])
	for s in get_tree().get_nodes_in_group("selling"):
		s.get_node("Button").connect("released", self, "sell_unit", [s])
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
	var fore = load("res://screens/market/foreground.tscn").instance()
	add_child(fore)

func _execute_event(event):
	._execute_event(event)
	var ev = event_scene.instance()
	var description = ev.get_node("CenterContainer/Panel/MarginContainer/Description")
	add_child(ev)
	if event == EVENT_1:
		if ceil(government.minimum_wage) < 9999:
			government.minimum_wage = ceil(rand_range(government.minimum_wage, government.minimum_wage + 2000))
			description.set_text(min_wage%government.minimum_wage)
			for worker in get_tree().get_nodes_in_group("buying"):
				if worker.type == 0 and worker.production < government.minimum_wage:
					if not worker.is_in_group("gatherer"):
						worker.queue_free()
		else:
			_execute_event(event +1)
	elif event == EVENT_2:
		var tax = government.machinery * 100
		machine_regulation = machine_regulation.format({"tax":tax})
		description.set_text(machine_regulation)
		for m in get_node("Buying/PanelContainer/MarginContainer/ScrollingContainer/List").get_children():
			if m.type == 1:
				m.price += m.price * government.machinery
	elif event == EVENT_3:
		new_contract_law = new_contract_law.format({"amount":government.minimum_demand})
		for c in get_node("ContractPanel/Panel/Contracts/ScrollContainer/VBoxContainer").get_children():
			if c.demand > government.minimum_demand:
				c.queue_free()
		description.set_text(new_contract_law)
	for t in get_tree().get_nodes_in_group("thumbnails"):
		t.update_description()
	
func buy_unit(unit):
	if (player.money - unit.price) >= 0 and (unit.monthly_cost + player.monthly_expenses) <= player.money:
		player.set_money(unit.price, player.BUY)
		var u = unit.duplicate()
		u.price *= 0.5
		u.remove_from_group("buying")
		u.add_to_group("selling")
		u.get_node("Button").connect("released", self, "sell_unit", [u])
		u.update_description()
		player.set_unities(u, player.ADD)

func sell_unit(unit):
	player.set_money(unit.price, player.SELL)
	player.set_unities(unit, player.REMOVE)
	
func sign_new_contract(signed, contract):
	if signed:
		player.set_contracts(player.get_contracts() + contract.demand)
	else:
		player.set_contracts(player.get_contracts() - contract.demand)
	print(player.get_contracts())

func _on_finish_released():
	var t = get_node("Tween")
	player.get_node("Company/Unities").hide()
	player.get_node("Info/Button").hide()
	t.interpolate_property(self, "rect/pos", get_pos(), get_pos() - Vector2(1024,0), 0.5, t.TRANS_BACK, t.EASE_IN)
	t.start()
	yield(t, "tween_complete")
	get_tree().change_scene(next_scene)
