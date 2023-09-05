extends CanvasLayer

@export_node_path("CharacterBody2D") var player_node ## Referência do jogador para ligar sinais.
@export_node_path("PathFollow2D") var camera_node ## Referência da câmera para ligar sinais.

const SHIELD_ACTIVE = preload("res://Assets/Sprites/UI/shield_counter.png")
const SHIELD_INACTIVE = preload("res://Assets/Sprites/UI/shield_counter_empty.png")

var object_under_count := 0 ## Contagem de objetos passando por baixo da UI.
var hide_tween_time := 0.3 ## Tempo para a UI ficar transparente caso um objeto toque nela.
var score := 0 ## O valor atual de score.

@onready var score_node := $Screen/Score as Label ## Texto de score.
@onready var shield_counters := $Screen/ShieldBG/ShieldCounters as HBoxContainer ## [Container] dos contadores de shield.
@onready var screen := $Screen as Control ## [Container] do visual compelto da UI.


# Funções virtuais
func _ready() -> void:
	_setup()


# Funções privadas
func _setup() -> void:
	if player_node == null or camera_node == null:
		push_error("Player node path empty")
		return
	await get_tree().process_frame
	var player = get_node_or_null(player_node)
	var camera = get_node_or_null(camera_node)
	if player == null:
		push_error("Player not loaded into UI")
		return
	if camera == null:
		push_error("Camera not loaded into UI")
		return
	player.shield_changed.connect(_on_shield_changed)
	player.life_changed.connect(_on_life_changed)
	camera.object_entered_ui.connect(_on_object_entered_ui)
	camera.object_exited_ui.connect(_on_object_exited_ui)


func _check_ui_visibility(mod: int) -> void:
	var prev_count = object_under_count
	object_under_count += mod
	object_under_count = max(object_under_count, 0)
	if prev_count == 0 and object_under_count > 0:
		var t := create_tween()
		t.tween_property(screen, "modulate", Color(1.0, 1.0, 1.0, 0.4), hide_tween_time)
	elif prev_count > 0 and object_under_count == 0:
		var t := create_tween()
		t.tween_property(screen, "modulate", Color.WHITE, hide_tween_time)


# Funções de sinal
func _on_shield_changed(new_shield : int) -> void:
	for i in range(shield_counters.get_child_count()):
		var counter = shield_counters.get_child(i) as TextureRect
		if i < new_shield:
			counter.texture = SHIELD_ACTIVE
		else:
			counter.texture = SHIELD_INACTIVE


func _on_life_changed(_new_life : int) -> void:
	pass


func _on_score_changed(added_score : int) -> void:
	score += added_score
	score_node.text = "SCORE: %07d" % score


func _on_object_entered_ui() -> void:
	_check_ui_visibility(1)


func _on_object_exited_ui() -> void:
	_check_ui_visibility(-1)
