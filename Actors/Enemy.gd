extends CharacterBody2D

@onready var navigation = $NavigationAgent2D ## movimentação automática
var navigating:bool = false ## auxiliar na navegação
@export var speed :float = 210.69 ## velocidade


func _physics_process(_delta):
	if Input.is_action_just_released('ui_select'):
		self.set_destination(get_global_mouse_position())
	navigate()

func navigate():
#	if navigation.is_target_reachable():
	var target = navigation.get_next_path_position()
	velocity = position.direction_to(target).normalized() * speed
	navigation.set_velocity(velocity)

func set_destination(new_dest):
		navigation.set_target_position(new_dest)
		navigating = true



func _on_navigation_finished():
	navigating = false



func _on_velocity_computed(safe_velocity):
	velocity = safe_velocity
	if navigating:
		move_and_slide()
