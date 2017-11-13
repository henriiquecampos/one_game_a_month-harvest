extends Node

var money = 1000 setget set_money
var production = 10 setget set_production
var monthly_expenses = 0 setget set_monthly_expenses
var unities = 0 setget set_unities
var contracts = 0 setget set_contracts,get_contracts
onready var company = get_node("Selling/PanelContainer/ScrollingContainer/List")
enum{ADD, REMOVE, SELL, BUY, HIRE, FIRE}

func set_unities(unit, type):
	if type == ADD:
		set_money(unit.price, BUY)
		set_monthly_expenses(unit.monthly_cost, HIRE)
	elif type == REMOVE:
		set_money(unit.price, SELL)
		set_monthly_expenses(unit.monthly_cost, FIRE)
		
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