extends CharacterBody2D

var speed = 300
var direction = Vector2(0, 1)

		
func _physics_process(delta):
	velocity = direction.normalized() * speed
	move_and_slide()
	if self.position.y > get_viewport_rect().size.y:
		queue_free()
