extends "res://Scripts/Classes/base_enemy.gd"

@export var min_shoot_timer := 1.0
@export var max_shoot_timer := 3.0

@onready var shoot_timer := $ShootTimer as Timer


func _ready() -> void:
	super._ready()
	shoot_timer.wait_time = randf_range(min_shoot_timer, max_shoot_timer)


func _on_screen_entered() -> void:
	super._on_screen_entered()
	print(name, " is processing")
	if shoot_timer.paused:
		shoot_timer.paused = false
	else:
		shoot_timer.start()


func _on_screen_exited() -> void:
	super._on_screen_exited()
	if not shoot_timer.is_stopped():
		shoot_timer.paused = true


func _on_shoot_timer_timeout() -> void:
	var player = get_tree().get_first_node_in_group("Player")
	if player:
		var target = player.global_position
		_shoot(target)
