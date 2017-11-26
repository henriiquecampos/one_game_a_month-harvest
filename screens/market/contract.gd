extends CheckBox

export (String, MULTILINE) var description
export (int) var demand
var tooltip = "produce {amount} in wheat"
func _ready():
	set_tooltip(tooltip.format({"amount":demand}))