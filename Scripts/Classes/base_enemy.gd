extends CharacterBody2D
## Inimigo que usa uma lista de [Path2D] para se localizar.
##
## Aqui, o inimigo ao ser acionado coloca um [Path2D] na sua posição e movimenta
## o [PathFollow2D] pra detectar onde é sua próxima posição. Ao terminar o
## caminho, o inimigo pode andar de novo ou desaparecer. Importante: não esquecer
## de excluir o [Path2D] ao excluir o personagem, já que eles não são parentes.

signal enemy_destroyed(score: int)

@export var speed: float = 210.0 ## Velocidade em pixels.
@export var score: int
@export var follow_camera := false
@export var path_list: Array[PackedScene]
@export var loop_paths := false
@export var rotate_with_path := false
@export_file("*.tscn") var bullet_scene

var path: Path2D
var path_follow: PathFollow2D
var entered_screen := false
var bullet

@onready var shoot_point := $ShootPoint as Marker2D
@onready var offscreen_timer := $OffscreenTimer as Timer


# Funções virtuais
func _ready() -> void:
	bullet = load(bullet_scene)
	path_list = path_list.duplicate()
	# Pra evitar que o inimigo tente acessar o Path2D antes de ele existir
	set_physics_process(false)
	_setup() # Em outra função pra não usar await dentro de _ready()


func _physics_process(delta):
	_move(delta)
	if path_follow.progress_ratio == 1: # Se o caminho tiver terminado
		_setup_next_path()


# Funções privadas
func _setup() -> void:
	# Carregar o Path2D e preencher as variáveis relacionadas
	await get_parent().ready
	if path_list.is_empty():
		push_error("No paths on array")
		return
	_setup_next_path()
	# Conectar o sinal à UI
	var ui = get_tree().get_first_node_in_group("UI")
	enemy_destroyed.connect(ui._on_score_changed.bind(score))


func _setup_next_path() -> void:
	if path != null:
		path.queue_free()
	if path_list.size() > 0:
		path = path_list.pop_front().instantiate() as Path2D
		get_parent().add_child(path)
		path.global_position = global_position
		path_follow = path.get_node("PathFollow2D")
		path_follow.rotates = rotate_with_path
	else:
		_remove()


func _move(delta: float) -> void:
	path_follow.progress += speed * delta
	velocity = path_follow.global_position - global_position
	velocity = velocity.normalized() * speed
	move_and_slide()
	if rotate_with_path:
		rotation = path_follow.rotation


func _remove(destroyed := false) -> void:
	if destroyed:
		enemy_destroyed.emit()
		# TODO: Animação para inimigo morrer
	path.queue_free()
	queue_free()


func _shoot(target: Vector2) -> void:
	var b := bullet.instantiate() as Area2D
	get_parent().add_child(b)
	b.global_position = shoot_point.global_position
	var target_dir := (target - b.global_position).normalized()
	b.launch(target_dir)


func _on_screen_entered() -> void:
	if not entered_screen:
		entered_screen = true
		set_physics_process(true)
	else:
		offscreen_timer.stop()


func _on_screen_exited() -> void:
	offscreen_timer.start()


func _on_offscreen_timer_timeout() -> void:
	_remove()
