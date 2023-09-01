extends PathFollow2D

signal object_entered_ui
signal object_exited_ui

@export_node_path("CharacterBody2D") var player_node ## Caminho para o node do Player.
@export var cam_speed := 50.0 ## Velocidade da câmera em pixels.

var previous_pos := Vector2.ZERO ## Posição anterior da câmera, usada para calcular offset.


# Funções virtuais
func _ready() -> void:
	previous_pos = global_position


func _physics_process(delta) -> void:
	progress += cam_speed * delta
	var offset = global_position - previous_pos
	_send_offset(offset)
	previous_pos = global_position


# Funções privadas
func _send_offset(offset : Vector2) -> void:
	var nodes := []
	for g in ["Player", "Enemy", "Bullet"]:
		nodes.append_array(get_tree().get_nodes_in_group(g))
	for n in nodes:
		n.camera_offset = offset


# Funções de sinal
func _on_ui_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player") or body.is_in_group("Enemy"):
		object_entered_ui.emit()


func _on_ui_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player") or body.is_in_group("Enemy"):
		object_exited_ui.emit()
