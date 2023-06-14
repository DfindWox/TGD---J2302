extends CharacterBody2D


@export var speed = 300.0


func _physics_process(delta):

	var input_vector = Vector2(
		Input.get_axis("ui_left", "ui_right"),
		Input.get_axis("ui_up", "ui_down")
	).normalized()
	velocity = input_vector * speed
	move_and_slide()
