extends Control

func _ready():
	$FondoPersonaje/Personaje.play("default")

func _on_misiones_pressed():
	GameManager.goto_scene("res://core/misiones.tscn")

func _on_tienda_pressed():
	GameManager.goto_scene("res://core/tienda.tscn")

func _on_personalizacion_pressed():
	GameManager.goto_scene("res://core/personalizacion.tscn")

func _on_jugar_m_pressed():
	GameManager.goto_scene("res://core/seleccion_mundos.tscn")

func _on_cambiarcuenta_pressed():
	print("Cambiar cuenta: funcion pendiente")