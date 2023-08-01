extends "res://Scripts/base_entity.gd"
@export var bullet: PackedScene
var target:bool = false

func shoot():
	var s = bullet.instantiate()
	s.direction = Vector2(-1, 0)
	s.own = 'enemy'
	owner.call_deferred("add_child", s)
	s.transform = $Marker.global_transform

func _on_timer_timeout():
	if target:
		shoot()
		$Timer.start()


func _on_radar_body_entered(body):
	if body.is_in_group('Player'):
		target = true
		shoot()
		$Timer.start()

func _on_radar_body_exited(body):
	if body.is_in_group('Player'):
		target = false


