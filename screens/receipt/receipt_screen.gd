extends "../abstract_screen.gd"
export (String, FILE, "*.tscn") var next_scene
onready var total = player.money
var earn = player.contracts
func _ready():
	for tax in government.taxes:
		print(government.taxes[tax])
		var d = get_node("Receipt/List/Label").duplicate()
		var text = "{tax} -{value}%"
		d.set_text(text.format({"tax":tax, "value":int(government.taxes[tax] * 100)}))
		get_node("Receipt/List").add_child(d)
		earn -= earn * government.taxes[tax]
	total += earn
	total -= player.monthly_expenses
	var d = get_node("Receipt/List/Label").duplicate()
	var text = "Contracts Payment: ${demand},00"
	d.set_text(text.format({"demand":player.contracts}))
	get_node("Receipt/List").add_child(d)
	d = get_node("Receipt/List/Label").duplicate()
	text = "Monthly Expenses: ${monthly},00"
	d.set_text(text.format({"monthly":player.monthly_expenses}))
	get_node("Receipt/List").add_child(d)
	d = get_node("Receipt/List/Label").duplicate()
	text = "Total After Deductions: ${total},00"
	d.set_text(text.format({"total":total}))
	get_node("Receipt/List").add_child(d)
	player.set_money(total)

func change_scene():
	var t = get_node("Tween")
	player.get_node("Company/Unities").hide()
	player.get_node("Info/Button").hide()
	t.interpolate_property(self, "rect/pos", get_pos(), get_pos() - Vector2(1024,0), 0.5, t.TRANS_BACK, t.EASE_IN)
	t.start()
	yield(t, "tween_complete")
	player.set_contracts(0)
	get_tree().change_scene(next_scene)
