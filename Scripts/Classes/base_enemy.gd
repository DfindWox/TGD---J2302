extends CharacterBody2D
## Inimigo que usa uma lista de [Path2D] para se localizar.
##
## Aqui, o inimigo ao ser acionado coloca um [Path2D] na sua posição e movimenta
## o [PathFollow2D] pra detectar onde é sua próxima posição. Ao terminar o
## caminho, o inimigo pode andar de novo ou desaparecer. Importante: não esquecer
## de excluir o [Path2D] ao excluir o personagem, já que eles não são parentes.

signal enemy_destroyed(score: int)

@export var score: int
@export var touch_damage: int
@export var life := 1
@export_file("*.tscn") var bullet_scene
@export var bullet_damage: int
@export var activation_delay := 0.0
@export_group("Movement")
@export var speed: float = 210.0 ## Velocidade em pixels.
@export var follow_camera := false
@export var path_list: Array[PackedScene]
@export var path_size_variation := Vector2(1.0, 1.0)
@export var loop_paths := false
@export var rotate_with_path := false

var path: Path2D
var path_follow: PathFollow2D
var path_count := 0
var entered_screen := false
var bullet: PackedScene
var hitbox_touch := []

@onready var shoot_point := $ShootPoint as Marker2D
@onready var offscreen_timer := $OffscreenTimer as Timer
@onready var enemy_collision := $Collision as CollisionShape2D
@onready var hitbox_collision := $Hitbox/Collision as CollisionShape2D
@onready var vis_notifier := $VisibleNotifier as VisibleOnScreenNotifier2D


# Funções virtuais
func _ready() -> void:
	# Pra evitar que o inimigo tente acessar o Path2D antes de ele existir
	set_physics_process(false)
	_setup() # Em outra função pra não usar await dentro de _ready()


func _physics_process(delta):
	_move(delta)
	if path_follow.progress_ratio == 1: # Se o caminho tiver terminado
		_setup_next_path()
	if hitbox_touch.size() > 0:
		for target in hitbox_touch:
			_hit(target)


# Funções públicas
func hurt(value := 1) -> void:
	life -= value
	if life <= 0:
		_remove(true)


# Funções privadas
func _setup() -> void:
	bullet = load(bullet_scene)
	path_list = path_list.duplicate()
	# Carregar o Path2D e preencher as variáveis relacionadas
	await get_parent().ready
	if path_list.is_empty():
		push_error("No paths on array")
		return
	_setup_next_path()
	# Conectar o sinal à UI
	var ui = get_tree().get_first_node_in_group("UI")
	enemy_destroyed.connect(ui._on_score_changed.bind(score))
	# Igualar a colisão do inimigo à hitbox (hack)
	hitbox_collision.shape = enemy_collision.shape
	hitbox_collision.rotation = enemy_collision.rotation


func _setup_next_path() -> void:
	if path != null:
		path.queue_free()
	if path_list.size() > 0:
		path = path_list[path_count].instantiate() as Path2D
		get_parent().add_child(path)
		path.scale = path_size_variation
		path.global_position = global_position
		path_follow = path.get_node("PathFollow2D")
		path_follow.rotates = rotate_with_path
		path_count = posmod(path_count + 1, path_list.size())
	else:
		_remove()


func _move(delta: float) -> void:
	path_follow.progress += speed * delta
	velocity = path_follow.global_position - global_position
	velocity = velocity.normalized() * speed
	move_and_slide()
	if rotate_with_path:
		rotation = path_follow.rotation
	if path_follow.progress_ratio == 1:
		if path_count == 0 and not loop_paths:
			_remove()


func _remove(destroyed := false) -> void:
	if destroyed:
		enemy_destroyed.emit()
		# TODO: Animação para inimigo morrer
	path.queue_free()
	queue_free()


func _shoot(target: Vector2) -> void:
	print(name, " shooting")
	var b := bullet.instantiate() as Area2D
	get_parent().add_child(b)
	b.global_position = shoot_point.global_position
	var target_dir := (target - b.global_position).normalized()
	b.launch(target_dir, self)


func _hit(target: Node2D) -> void:
	target.hurt(touch_damage)


func _on_screen_entered() -> void:
	if not entered_screen:
		entered_screen = true
		await get_tree().create_timer(activation_delay).timeout
		set_physics_process(true)
	else:
		offscreen_timer.stop()


func _on_screen_exited() -> void:
	if not is_physics_processing():
		entered_screen = false
	else:
		offscreen_timer.start()


func _on_offscreen_timer_timeout() -> void:
	_remove()


func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		hitbox_touch.append(body)


func _on_hitbox_body_exited(body: Node2D) -> void:
	hitbox_touch.erase(body)
