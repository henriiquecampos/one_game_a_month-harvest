extends Node

var taxes = {"federal":0.12, "state":0.10, "payroll":0.15, "unenmployment":0.08, "sales": 0.06, "value added": 0.04}
var machinery = 0.25
export (int) var minimum_wage = 2000
export (int) var minimum_demand = 4000
func _ready():
	for tax in taxes:
#		print("%s: %s"%[tax, taxes[tax]])
		pass