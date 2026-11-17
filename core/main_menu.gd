extends Control

func _on_jugar_button_pressed():
	GameManager.goto_scene("res://core/world_map.tscn")

func _on_iniciar_sesion_pressed():
	print("Iniciar sesion: funcion pendiente")
