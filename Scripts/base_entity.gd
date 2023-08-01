extends CharacterBody2D


@export var speed = 300.0
@export var life = 1

func _physics_process(_delta):
	pass

func take_damage():
	life =-1
	if life <=0:
		print('morri, minha life: ', life)
		self.queue_free()
