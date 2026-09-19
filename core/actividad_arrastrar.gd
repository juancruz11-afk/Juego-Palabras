extends Control
class_name ActividadArrastrar

const ESCENA_TARJETA := preload("res://core/palabra_card.tscn")
const ESCENA_CUBETA := preload("res://core/cubeta_zona.tscn")

@export var banco_palabras: WordBank
@export var palabras_por_ronda: int = 8

@onready var zona_cubetas: HBoxContainer = $Diseno/ZonaCubetas
@onready var zona_tarjetas: HFlowContainer = $Diseno/ZonaTarjetas

var total_palabras: int = 0
var aciertos: int = 0

func _ready() -> void:
	iniciar_actividad()

func iniciar_actividad() -> void:
	limpiar()
	crear_cubetas()
	repartir_tarjetas()

func limpiar() -> void:
	for hijo in zona_cubetas.get_children():
		hijo.queue_free()
	for hijo in zona_tarjetas.get_children():
		hijo.queue_free()
	aciertos = 0
	total_palabras = 0

func crear_cubetas() -> void:
	for categoria in banco_palabras.categorias:
		var cubeta := ESCENA_CUBETA.instantiate()
		cubeta.etiqueta_categoria = categoria.etiqueta
		cubeta.palabra_soltada.connect(_on_palabra_soltada)
		zona_cubetas.add_child(cubeta)

func repartir_tarjetas() -> void:
	var todas: Array = []
	for categoria in banco_palabras.categorias:
		for palabra in categoria.palabras:
			todas.append({"palabra": palabra, "categoria": categoria.etiqueta})

	todas.shuffle()
	var cantidad: int = min(palabras_por_ronda, todas.size())
	total_palabras = cantidad

	for i in range(cantidad):
		var dato = todas[i]
		var tarjeta := ESCENA_TARJETA.instantiate()
		tarjeta.palabra = dato["palabra"]
		tarjeta.categoria_correcta = dato["categoria"]
		zona_tarjetas.add_child(tarjeta)

func _on_palabra_soltada(es_correcta: bool, _tarjeta: PalabraCard) -> void:
	if es_correcta:
		aciertos += 1
		if aciertos >= total_palabras:
			completar_actividad()

func completar_actividad() -> void:
	if GameManager:
		GameManager.add_coins(10)
	print("Actividad completada")
	await get_tree().create_timer(2.0).timeout
	GameManager.goto_scene("res://core/seleccion_mundos.tscn")

func _on_boton_regresar_pressed() -> void:
	GameManager.goto_scene("res://core/seleccion_mundos.tscn")