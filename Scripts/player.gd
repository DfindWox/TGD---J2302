extends CharacterBody2D

signal player_dead ## Emitido quando o jogador morre.
signal shield_changed ## Emitido quando o jogador perde/ganha escudos.
signal life_changed ## Emitido quando o jogador perde/ganha vida.

@export var life := 2 ## Vida do jogador.
@export var shield := 0 ## Nível de escudos do jogador.
@export_range(0, 1, 0.01) var direction_lerp := 0.75 ## Nível de lerp entre a velocidade prévia e a atual.
@export var speed := 240.0 ## Velocidade máxima da nave.
@export var parry_time := 0.4 ## Tempo em que o parry fica ativo.
@export var parry_delay := 0.4 ## Tempo que o jogador precisa esperar para reativar o parry.
@export var bullet : PackedScene ## Cena da bala que a nave atira.
@export var shoot_delay := 0.3 ## Intervalo entre tiros.

var is_active := true ## Define se a nave está ativa e pode receber comandos do jogador.
var can_parry := true ## Emitido quando o jogador morre.

@onready var parry_shape := $ParryArea/Collision as CollisionShape2D ## [CollisionShape2D] responsável pelo parry.
@onready var shoot_delay_timer := $ShootDelay as Timer ## [Timer] que determina o tempo entre tiros.
@onready var shoot_point := $ShootPoint as Marker2D ## [Marker2D] que indica de onde saem os tiros.


# Funções básicas
func _ready() -> void:
	shoot_delay_timer.wait_time = shoot_delay


func _physics_process(delta: float) -> void:
	if is_active:
		_move(delta)
		if Input.is_action_just_pressed("Parry"):
			_parry()
		if Input.is_action_just_pressed("shoot"):
			_shoot()


# Funções públicas
func hurt(value := 1) -> void:
	if shield > 0:
		shield -= min(value, shield)
		shield_changed.emit()
	else:
		life -= min(life, value)
		life_changed.emit()
		if life <= 0:
			_die()


# Funções privadas (não podem ser chamadas diretamente por outros objetos)
func _move(_delta: float) -> void:
	var input_dir := _get_input_vector()
	var new_vel = input_dir * speed
	velocity = velocity.lerp(new_vel, direction_lerp)
	move_and_slide()


func _get_input_vector() -> Vector2:
	var dir = Vector2()
	dir.x = Input.get_axis("ui_left", "ui_right")
	dir.y = Input.get_axis("ui_up", "ui_down")
	if dir.length() >= 1.0:
		return dir.normalized()
	else:
		return dir


func _parry() -> void:
	if can_parry:
		can_parry = false
		parry_shape.set_deferred("disabled", false)
		await get_tree().create_timer(parry_time).timeout
		parry_shape.set_deferred("disabled", true)
		await get_tree().create_timer(parry_delay).timeout
		can_parry = true


func _shoot() -> void:
	if shoot_delay_timer.is_stopped():
		var b := bullet.instantiate()
		get_tree().current_scene.add_child(b)
		b.global_position = shoot_point.global_position
		shoot_delay_timer.start()


func _die() -> void:
	player_dead.emit()
	queue_free()
