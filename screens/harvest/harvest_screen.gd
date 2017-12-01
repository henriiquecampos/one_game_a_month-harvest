extends "../abstract_screen.gd"
onready var description_node = get_node("ProgressBar/Amount")
onready var description = description_node.get_text()
onready var time_node = get_node("ProgressBar/Time")
onready var time_text = time_node.get_text()
onready var progress = get_node("ProgressBar")
onready var tiles = get_node("Harvest/Field/Tiles")
var player_label
var total = 0
export (String, FILE, "*.tscn") var next_scene
var time = 0.0
var days = 0 
var already_harvested = false
var current = 0
var current_tile = 0 setget set_current_tiles

func _ready():
	time_node.set_text(time_text.format({"time":days}))
	_on_tiles_changed(get_node("Harvest/Field/Tiles"))
	yield(get_node("Tween"), "tween_complete")
	if !player.already_played:
		get_node("Help/Control").show()
	else:
		get_node("Help").queue_free()
	yield(get_node("Help"), "exit_tree")
	var s = load("res://screens/harvest/frontground.tscn").instance()
	add_child(s)
	player.set_theme(get_theme())
	player.get_node("Info/Button").set_theme(get_theme())
	player.get_node("Info/Panel").set_theme(get_theme())
	player_label = player.get_node("Info/Panel/MarginContainer/Text").get("custom_colors/font_color")
	player.get_node("Info/Panel/MarginContainer/Text").set("custom_colors/font_color", Color("f7d79d"))
	player.get_node("Info/Button").show()

func _on_tiles_changed( tilemap ):
	total = player.total_tiles
	var d = description.format({"total":total, "current":current})
	description_node.set_text(d)
	progress.set_max(total)
	
func set_current_tiles(value):
	if value > current_tile and value < 6:
		current_tile = value
		_on_change_tile(current_tile)

func _process(delta):
	if current <= total:
		current += ceil((player.production * delta)/30)
		var d = description.format({"total":player.total_tiles, "current":int(current)})
		description_node.set_text(d)
		time += delta
		days = int(time)
		var dd = time_text.format({"time":days})
		time_node.set_text(dd)
		progress.set_value(current)
		set_current_tiles(int((current/total) * 6))
	else:
		_on_harvest_toggled(false)

func _on_harvest_toggled( pressed ):
	set_process(pressed)
	if already_harvested:
		player.get_node("Info/Panel/MarginContainer/Text").set("custom_colors/font_color", player_label)
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
		player.tile_price += player.contracts - current
		player.produced = current
		get_node("Button").set_text("Deliver")
		already_harvested = true
		
func _on_change_tile(tile):
	if tile + 1 < 6:
		for t in tiles.get_used_cells_by_id(tile):
			tiles.set_cell(t.x, t.y, tile + 1)