extends CheckBox

export (String, MULTILINE) var description
export (int) var demand

func _on_about_toggled( pressed ):
	description = description.format({"amount":demand})
	get_node("Description").set_hidden(!pressed)
	get_node("Description/Panel/Label").set_text(get_node("Description/Panel/Label").get_text().format({"about":description}))
