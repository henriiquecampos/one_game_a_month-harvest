extends Node

export (int) var price = 100
export (float) var monthly_cost = 300
export (int) var production = 2000
export (int, "WORKER", "MACHINE") var type = 0
export (String, MULTILINE) var description = ""
func _ready():
	if type == 0:
		description = description%[monthly_cost, production, "Worker"]
	elif type == 1:
		description = description%[price, monthly_cost, production, "Machine"]
	get_node("Description").set_text(description)