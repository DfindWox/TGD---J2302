extends CharacterBody2D

var speed = 400
var direction = Vector2(-1, 0)


func _physics_process(delta: float) -> void:
	velocity = direction.normalized() * speed
	move_and_slide()
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		if collision.get_collider().is_in_group("enemies"):
			collision.get_collider().queue_free()
			queue_free()
