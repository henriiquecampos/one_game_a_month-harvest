extends Node

var money = 1000 setget set_money
var production = 10 setget set_production
var monthly_expenses = 500 setget set_monthly_expenses
var unities = [] setget set_unities
enum{ADD, REMOVE, SELL, BUY, HIRE, FIRE}

func set_unities(unit, type):
	if type == ADD:
		unities.append(unit)
	elif type == REMOVE:
		unities.remove(unit)
		
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