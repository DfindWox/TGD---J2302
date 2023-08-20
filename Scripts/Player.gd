extends CharacterBody2D

@export var life = 2
@export var acceleration = 1.1
@export var des_acc_mod = 2 #desacceleration modifier
@export var speed = 240
@onready var parring = $ParryTimer
var motion = Vector2()
var parying:bool = true
@export var bullet: PackedScene

func take_damage():
	life -= 1
	if life <=0:
		print('morri, minha life: ', life)
		get_tree().reload_current_scene()

	
func _physics_process(delta):
	move(delta)
	parry()
	shoot()

func move(delta):
	#rewrite that
#	var motion = Vector2(
#		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
#		Input.get_action_strength("ui_down")  - Input.get_action_strength("ui_up")
#	).normalized()
	if Input.is_action_pressed("ui_right"):
		motion.x = min(motion.x + acceleration * delta, speed)
	elif Input.is_action_pressed("ui_left"):
		motion.x = max(motion.x - acceleration * delta, -speed)
	else:
		if motion.x > 0:
			motion.x = max(motion.x - acceleration *des_acc_mod* delta, 0)
		if motion.x < 0:
			motion.x = min(motion.x + acceleration *des_acc_mod* delta, 0)

	if Input.is_action_pressed("ui_up"):
		motion.y = max(motion.y - acceleration * delta, -speed)
	elif Input.is_action_pressed("ui_down"):
		motion.y = min(motion.y + acceleration * delta, speed)
	else:
		if motion.y > 0:
			motion.y = max(motion.y - acceleration * delta * des_acc_mod, 0)
		if motion.y < 0:
			motion.y = min(motion.y + acceleration * delta * des_acc_mod, 0) 
	

	velocity = motion * speed
	move_and_slide()

func parry():
	if Input.is_action_pressed("Parry"):
		parring.start()
		$ParryArea/Collision.disabled = false
		parying = true

func shoot() -> void:
	if Input.is_action_pressed("shoot"):
		if($Timer.is_stopped()):
			$Timer.start()
			var GrabedInstance = bullet.instantiate()
			get_tree().current_scene.add_child(GrabedInstance)
			GrabedInstance.global_position = self.global_position
			GrabedInstance.global_position.x = self.global_position.x + 50


func _on_parry_timer_timeout():
	$ParryArea/Collision.disabled = true
	parying = false


func _on_parry_area_area_entered(area):
	print('parry achou: ', area)
	if area.is_in_group('bullet'):
		area.queue_free()
