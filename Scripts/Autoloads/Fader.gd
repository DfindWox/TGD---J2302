extends CanvasLayer
## Fade simples
##
## Ferramenta para criar fades simples de forma efetiva.

signal fade_finished ## Sinal que avisa quando a operação de fade se conclui.

var fade_time := 0.5 ## Tempo padrão de duração do fade.
var is_fading := false ## Para saber se o fade está acontecendo.

@onready var color = $Color ## Cor usada para o fade.


# Funções virtuais
func _ready() -> void:
	pass


# Funções públicas
## Muda o fade imediatamente.
func set_transparent(value: bool):
	if not is_fading:
		color.modulate = Color.TRANSPARENT if value else Color.WHITE


## Fade in direto.
func fade_in():
	_fade(true)


## Fade out direto.
func fade_out():
	_fade(false)


# Funções privadas
func _fade(fading_in: bool):
	var col = Color.TRANSPARENT if fading_in else Color.WHITE
	var prev = Color.WHITE if fading_in else Color.TRANSPARENT
	if not is_fading:
		is_fading = true
		color.modulate = prev
		var tween = create_tween()
		tween.finished.connect(_on_tween_finished)
		tween.tween_property(color, "modulate", col, 0.5)


func _on_tween_finished():
	is_fading = false
	fade_finished.emit()
