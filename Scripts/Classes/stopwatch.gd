extends Node

@export var autostart := false

var h := 0.0
var m := 0.0
var s := 0.0
var is_running := false


func _process(delta: float) -> void:
	if is_running:
		s += delta
		if s >= 60:
			s -= 60
			m += 1
		if m >= 60:
			m -= 60
			h += 1


func start() -> void:
	if is_running:
		return
	is_running = true


func stop() -> void:
	is_running = false


func reset() -> void:
	h = 0
	m = 0
	s = 0


func get_time() -> String:
	var result := "%02d" % h
	result += ":" + "%02d" % m
	result += ":" + "%02d" % s
	return result
