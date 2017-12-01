extends "../abstract_screen.gd"
export (String, FILE, "*.tscn") var next_scene
onready var total = player.money
var earn = 0
var foreground = preload("res://screens/receipt/foreground.tscn")
func _ready():
	for i in player.get_node("Info").get_children():
		i.set_theme(get_theme())
	player.contracts = min(player.produced, player.contracts)
	earn = player.contracts
	yield(get_node("Tween"), "tween_complete")
	if !player.already_played:
		get_node("Help/Control").show()
	else:
		get_node("Help").queue_free()
	yield(get_node("Help"), "exit_tree")
	var s = foreground.instance()
	add_child(s)
	for tax in government.taxes:
		var d = get_node("Receipt/List/Label").duplicate()
		d.set_align(0)
		d.set("custom_colors/font_color", Color("fa4973"))
		var text = "{tax} -{value}%"
		d.set_text(text.format({"tax":tax, "value":int(government.taxes[tax] * 100)}))
		d.set_percent_visible(0.0)
		get_node("Receipt/List").add_child(d)
		d.get_node("Animator").play("text")
		yield(d.get_node("Animator"), "finished")
		earn -= earn * government.taxes[tax]
	print(earn)
	total += earn
	total -= player.monthly_expenses
	var d = get_node("Receipt/List/Label").duplicate()
	d.set_align(0)
	var text = "Contracts Payment: ${demand},00"
	d.set("custom_colors/font_color", Color("14a890"))
	d.set_text(text.format({"demand":player.contracts}))
	d.set_percent_visible(0.0)
	get_node("Receipt/List").add_child(d)
	d.get_node("Animator").play("text")
	yield(d.get_node("Animator"), "finished")
	
	d = get_node("Receipt/List/Label").duplicate()
	d.set_align(0)
	d.set("custom_colors/font_color", Color("fa4973"))
	text = "Monthly Expenses: ${monthly},00"
	d.set_text(text.format({"monthly":int(player.monthly_expenses)}))
	d.set_percent_visible(0.0)
	get_node("Receipt/List").add_child(d)
	d.get_node("Animator").play("text")
	yield(d.get_node("Animator"), "finished")
	d = get_node("Receipt/List/Label").duplicate()
	d.set_align(0)
	text = "Total After Deductions: ${total},00"
	if total <= 0:
		d.set("custom_colors/font_color", Color("fa4973"))
	else:
		d.set("custom_colors/font_color", Color("14a890"))
	d.set_text(text.format({"total":int(total)}))
	d.set_percent_visible(0.0)
	get_node("Receipt/List").add_child(d)
	d.get_node("Animator").play("text")
	yield(d.get_node("Animator"), "finished")
	player.set_money(int(total))
	player.already_played = true
	if total <= 0:
		var g = load("res://objects/gameover.tscn").instance()
		add_child(g)
	else:
		if player.current_round > 4:
			#Win Condition
			next_scene = "res://screens/win/win_screen.tscn"
			change_scene()
		get_node("Button").show()
func change_scene():
	var t = get_node("Tween")
	player.get_node("Company/Unities").hide()
	player.get_node("Info/Button").hide()
	t.interpolate_property(self, "rect/pos", get_pos(), get_pos() - Vector2(1024,0), 0.5, t.TRANS_BACK, t.EASE_IN)
	t.start()
	yield(t, "tween_complete")
	player.set_contracts(0)
	get_tree().change_scene(next_scene)
