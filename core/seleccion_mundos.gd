
extends Control

@export var texturas_mundos: Array[Texture2D] = []

var indice_actual: int = 0

func _ready():
	actualizar_mundo()

func _on_regresar_button_pressed():
	GameManager.goto_scene("res://core/world_map.tscn")

func _on_flecha_r_pressed():
	if indice_actual < texturas_mundos.size() - 1:
		indice_actual += 1
		actualizar_mundo()

func _on_flecha_l_pressed():
	if indice_actual > 0:
		indice_actual -= 1
		actualizar_mundo()

func _on_m_bosque_pressed():
	match indice_actual:
		0:
			GameManager.goto_scene("res://worlds/bosque/mapa_bosque.tscn")
		1:
			GameManager.goto_scene("res://worlds/playa_letras/mapa_playa.tscn")
		2:
			GameManager.goto_scene("res://worlds/desierto/mapa_desierto.tscn")
		3:
			GameManager.goto_scene("res://worlds/volcan/mapa_volcan.tscn")
		4:
			GameManager.goto_scene("res://worlds/universo/mapa_universo.tscn")
		_:
			print("Mundo seleccionado: ", indice_actual + 1, " - pendiente de contenido")

func actualizar_mundo():
	$MBosque.texture_normal = texturas_mundos[indice_actual]
	$FlechaL.visible = indice_actual > 0
	$FlechaR.visible = indice_actual < texturas_mundos.size() - 1
