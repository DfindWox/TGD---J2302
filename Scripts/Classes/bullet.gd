extends Area2D

signal bullet_destroyed

@export var speed := 300.0

var dir := Vector2.ZERO
var has_launched := false ## Para saber se o tiro já saiu


# Funções virtuais
func _process(delta: float) -> void:
	if has_launched:
		global_position += dir * speed * delta


# Funções públicas
func launch(direction: Vector2) -> void:
	if dir.is_zero_approx():
		push_error("Bullet received no direction")
		return
	else:
		dir = direction
		rotation = dir.angle()


# Funções privadas
func _hit(obj: Node2D) -> void:
	if obj.has_method("hurt"):
		obj.hurt()
		bullet_destroyed.emit()
		queue_free()
	elif _is_environment(obj):
		bullet_destroyed.emit()
		queue_free()
	else:
		push_error("Unexpected object hit: ", obj.name)


#Funções auxiliares
func _is_environment(obj: CollisionObject2D) -> bool:
	if obj.get_collision_layer_value(6):
		return true
	else:
		return false


# Funções de sinal
func _on_body_entered(body: Node2D) -> void:
	_hit(body)
