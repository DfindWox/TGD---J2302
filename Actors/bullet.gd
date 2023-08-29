extends Area2D

var bullet_speed := 400 ## Velocidade do tiro.
var direction := Vector2.RIGHT ## Direção para onde o tiro vai.


# Funções básicas
func _ready() -> void:
	direction = direction.normalized()


func _physics_process(delta) -> void:
	global_position += direction * bullet_speed * delta


func _hit(target: Node2D) -> void:
	if target.has_method("hurt"):
		target.hurt()
	queue_free()
