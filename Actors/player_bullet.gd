extends "res://Scripts/Classes/bullet.gd"



func _on_visibility_notifier_screen_exited() -> void:
	queue_free()
