extends Node

var taxes = {"ICMS":0.2, "IPVA": 0.08}

func _ready():
	for tax in taxes:
		print("%s: %s"%[tax, taxes[tax]])