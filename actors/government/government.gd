extends Node

var taxes = {"Machinery":0.25, "IPVA": 0.08}
export (int) var minimum_wage = 2000
export (int) var minimum_demand = 4000
func _ready():
	for tax in taxes:
#		print("%s: %s"%[tax, taxes[tax]])
		pass