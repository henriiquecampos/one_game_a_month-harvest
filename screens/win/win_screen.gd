extends "../abstract_screen.gd"

func _ready():
	yield(get_node("Tween"), "tween_complete")
	get_node("Info/Label").set_text(get_node("Info/Label").get_text().format({"total":int(player.money)}))
	var s = load("res://screens/harvest/frontground.tscn").instance()
	add_child(s)
	get_node("Info/Animator").play("text")
