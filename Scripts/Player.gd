extends CharacterBody2D

var speed = 200
const bullet = preload("res://Prefabs/bullet.tscn")

func _process(delta: float) -> void:
	velocity = Vector2()

	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1 
		
	shoot()
	
func _physics_process(delta):
	velocity = velocity.normalized() * speed
	move_and_slide()
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		if collision.get_collider().is_in_group("enemies"):
			queue_free()
	
func shoot() -> void:
	if Input.is_action_pressed("shoot"):
		if($Timer.is_stopped()):
			$Timer.start()
			var GrabedInstance = bullet.instantiate()
			get_tree().current_scene.add_child(GrabedInstance)
			GrabedInstance.global_position = self.global_position
			GrabedInstance.global_position.y = self.global_position.y - 50
