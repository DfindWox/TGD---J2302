extends "res://Scripts/Classes/base_enemy.gd"

@export_range(0.0, 1.0, 0.01) var starting_offset := 0.0
@export var shoot_stop_time := 0.2

var is_moving := true

@onready var shoot_timer := $ShootTimer as Timer


func _setup() -> void:
	super._setup()
	await get_parent().ready
	path_follow.progress_ratio = starting_offset


func _move(delta: float) -> void:
	if is_moving:
		super._move(delta)


func _on_screen_entered() -> void:
	if not entered_screen:
		shoot_timer.start()
	super._on_screen_entered()


func _on_shoot_timer_timeout() -> void:
	is_moving = false
	var player = get_tree().get_first_node_in_group("Player")
	if player:
		var target = player.global_position
		_shoot(target)
	await get_tree().create_timer(shoot_stop_time).timeout
	shoot_timer.start()
	is_moving = true
