extends Control

@export_file("*.tscn") var game_start_scene ## Scene para a primeira fase do jogo.


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Fader.fade_in()


# Funções de sinal
func _on_start_pressed() -> void:
	Fader.fade_out()
	await Fader.fade_finished
	Fader.fade_in(0.1)
	get_tree().change_scene_to_file(game_start_scene)


func _on_credits_pressed() -> void:
	pass # Replace with function body.


func _on_quit_pressed() -> void:
	Fader.fade_out()
	await Fader.fade_finished
	get_tree().quit()
