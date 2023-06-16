extends StaticBody2D
const enemy = preload("res://Prefabs/enemy.tscn")

func _ready():
	pass # Replace with function body.


func _physics_process(delta):
	if($Timer.is_stopped()):
			$Timer.start()
			SpawnEnemy()
	
func SpawnEnemy() -> void:
	var EnemiesInstance = enemy.instantiate()
	get_tree().current_scene.add_child(EnemiesInstance)
	EnemiesInstance.global_position = self.global_position
	EnemiesInstance.global_position.x = randf_range(50.0, 500.0)
