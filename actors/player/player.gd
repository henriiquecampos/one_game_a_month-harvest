extends Node

var money = 100000 setget set_money
var production = 2000 setget set_production
var monthly_expenses = 0 setget set_monthly_expenses
var unities = 0 setget set_unities
var contracts = 0 setget set_contracts,get_contracts
var tile_price = 200
var total_tiles = 0
var earned = 0
onready var info_node = get_node("Info/Panel/MarginContainer/Text")
onready var info_text = get_node("Info/Panel/MarginContainer/Text").get_text()
onready var company = get_node("Company/Unities/PanelContainer/MarginContainer/ScrollingContainer/List")
enum{ADD, REMOVE, SELL, BUY, HIRE, FIRE, SET}

func set_unities(unit, type):
	if type == ADD:
		set_monthly_expenses(unit.monthly_cost, HIRE)
		set_production(production + unit.production)
		company.add_child(unit)
	elif type == REMOVE:
		set_monthly_expenses(unit.monthly_cost, FIRE)
		set_production(production - unit.production)
		unit.queue_free()
		company.remove_child(unit)

func set_monthly_expenses(amount, type = 6):
	if type == HIRE:
		monthly_expenses += amount
	elif type == FIRE:
		monthly_expenses -= amount
	else:
		monthly_expenses = amount
		
func set_money(amount, type = 6):
	if type == SELL:
		money += amount
	elif type == BUY:
		money -= amount
	else:
		money = amount
		
func set_production(amount):
	production = amount
	
func set_contracts(value):
	contracts = value

func get_contracts():
	return(contracts)

func _on_info_toggled( pressed ):
	if pressed:
		get_node("Info/Panel").show()
		get_node("Info/Background").show()
		update_info()
	else:
		get_node("Info/Panel").hide()
		get_node("Info/Background").hide()

func update_info():
	var d = info_text.format({"money":money, "production":production, "expenses":monthly_expenses, 
	"demand":contracts, "tiles":total_tiles, "earning":int(contracts - monthly_expenses)})
	info_node.set_text(d)