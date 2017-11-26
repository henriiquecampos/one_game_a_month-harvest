extends Node

var taxes = {"Federal":0.12, "State":0.10, "Payroll":0.15, "Unenmployment":0.08, "Sales": 0.06, "ValueAdded": 0.04}
var machinery = 0.25
export (int) var minimum_wage = 2000
export (int) var minimum_demand = 4000
func _ready():
	for tax in taxes:
#		print("%s: %s"%[tax, taxes[tax]])
		pass