extends Node

var money = 1000000 setget set_money
var production = 0 setget set_production
var monthly_expenses = 0 setget set_monthly_expenses
var unities = 0 setget set_unities
var contracts = 0 setget set_contracts,get_contracts
onready var info_node = get_node("Info/Panel/MarginContainer/Text")
onready var info_text = get_node("Info/Panel/MarginContainer/Text").get_text()
onready var company = get_node("Company/Unities/PanelContainer/ScrollingContainer/List")
enum{ADD, REMOVE, SELL, BUY, HIRE, FIRE}

func set_unities(unit, type):
	if type == ADD:
		set_money(unit.price, BUY)
		set_monthly_expenses(unit.monthly_cost, HIRE)
		set_production(production + unit.production)
	elif type == REMOVE:
		set_money(unit.price, SELL)
		set_monthly_expenses(unit.monthly_cost, FIRE)
		set_production(production - unit.production)
		
	print("%s %s"%[money, monthly_expenses])
func set_monthly_expenses(amount, type):
	if type == HIRE:
		monthly_expenses += amount
	elif type == FIRE:
		monthly_expenses -= amount
		
func set_money(amount, type):
	if type == SELL:
		money += amount
	elif type == BUY:
		money -= amount
		
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
	var d = info_text.format({"money":money, "production":production, "expenses":monthly_expenses, "demand":contracts})
	info_node.set_text(d)