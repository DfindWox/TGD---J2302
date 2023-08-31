extends Control

@export_file("*.tscn") var main_menu ## Arquivo da tela de menu.


func _ready() -> void:
	Fader.set_transparent(false)
	await get_tree().create_timer(0.5).timeout
	Fader.fade_in()
	await Fader.fade_finished
	await get_tree().create_timer(1.0).timeout
	Fader.fade_out()
	await Fader.fade_finished
	get_tree().change_scene_to_file(main_menu)
