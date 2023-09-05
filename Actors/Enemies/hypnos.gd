extends "res://Scripts/Classes/base_enemy.gd"

@export var min_shoot_timer := 1.0
@export var max_shoot_timer := 3.0

@onready var shoot_timer := $ShootTimer as Timer


func _ready() -> void:
	super._ready()
	shoot_timer.wait_time = randf_range(min_shoot_timer, max_shoot_timer)


func _on_screen_entered() -> void:
	if not entered_screen:
		shoot_timer.start()
	super._on_screen_entered()


func _on_shoot_timer_timeout() -> void:
	var target = get_tree().get_first_node_in_group("Player").global_position
	_shoot(target)
