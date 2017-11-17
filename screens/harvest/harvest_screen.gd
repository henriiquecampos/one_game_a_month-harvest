extends "../abstract_screen.gd"
onready var description_node = get_node("ProgressBar/Amount")
onready var description = description_node.get_text()
onready var time_node = get_node("ProgressBar/Time")
onready var time_text = time_node.get_text()
onready var progress = get_node("ProgressBar")

export (String, FILE, "*.tscn") var next_scene
var time = 0.0
var days = 0 
var already_harvested = false
var current = 0
func _ready():
	time_node.set_text(time_text.format({"time":days}))
	_on_tiles_changed(get_node("Harvest/Field/Tiles"))

func _on_tiles_changed( tilemap ):
	print(tilemap.get_used_cells_by_id(0).size())
	var total = player.total_tiles
	var d = description.format({"total":total, "current":current})
	description_node.set_text(d)
	progress.set_max(total)

func _process(delta):
	current += floor(player.production * delta)
	var d = description.format({"total":player.total_tiles, "current":current})
	description_node.set_text(d)
	time += delta * 2
	print(time)
	days = int(time)
	var dd = time_text.format({"time":days})
	time_node.set_text(dd)
	progress.set_value(current)

func _on_harvest_toggled( pressed ):
	set_process(pressed)
	if already_harvested:
		set_process(false)
		var t = get_node("Tween")
		player.get_node("Company/Unities").hide()
		player.get_node("Info/Button").hide()
		t.interpolate_property(self, "rect/pos", get_pos(), get_pos() - Vector2(1024,0), 0.5, t.TRANS_BACK, t.EASE_IN)
		t.start()
		yield(t, "tween_complete")
		get_tree().change_scene(next_scene)
	if pressed:
		get_node("Button").set_text("Stop")
	else:
		get_node("Button").set_text("Deliver")
		already_harvested = true