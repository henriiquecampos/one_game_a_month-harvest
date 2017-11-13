extends Control

enum events {EVENT_1, EVENT_2, EVENT_3}

func _ready():
	randomize()
	_execute_event(randi()%3)

func _execute_event(event):
	pass