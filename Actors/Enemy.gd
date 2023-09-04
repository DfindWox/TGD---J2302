extends CharacterBody2D
## Inimigo que usa [Path2D] para se localizar.
##
## Aqui, o inimigo ao ser acionado coloca um [Path2D] na sua posição e movimenta
## o [PathFollow2D] pra detectar onde é sua próxima posição. Ao terminar o
## caminho, o inimigo pode andar de novo ou desaparecer. Importante: não esquecer
## de excluir o [Path2D] ao excluir o personagem, já que eles não são parentes.

@export var speed :float = 210.0 ## Velocidade em pixels.
@export_file("*.tscn") var path_file ## Caminho que o inimigo vai seguir.

var path : Path2D
var path_follow : PathFollow2D


# Funções virtuais
func _ready() -> void:
	# Pra evitar que o inimigo tente acessar o Path2D antes de ele existir
	set_physics_process(false)
	_setup() # Em outra função pra não usar await dentro de _ready()


func _physics_process(delta):
	path_follow.progress += speed * delta # PathFollow2D anda dentro do caminho
	if path_follow.progress_ratio == 1: # Se o caminho tiver terminado
		path.queue_free()
		queue_free()
	# Velocidade vai baseada na distância entre o inimigo e o PathFollow2D
	velocity = path_follow.global_position - global_position
	# Necessário normalizar e multiplicar por speed pq move_and_slide vai multiplicar
	# de novo por delta
	velocity = velocity.normalized() * speed
	move_and_slide()


# Funções privadas
func _setup() -> void:
	# Função pra criar o Path2D e preencher as variáveis relacionadas
	await get_parent().ready
	path = load(path_file).instantiate() as Path2D
	# Path2D como filho do node pai porque senão ele se move junto do inimigo
	get_parent().add_child(path)
	path.global_position = global_position
	path_follow = path.get_node("PathFollow2D")
	# Agora sim pode ligar o physics_process
	set_physics_process(true)
