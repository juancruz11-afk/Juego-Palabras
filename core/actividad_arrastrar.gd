extends Control
class_name ActividadArrastrar

enum Ventana { PAUSA, GANAR, PERDER }

const ESCENA_TARJETA := preload("res://core/palabra_card.tscn")
const ESCENA_CUBETA := preload("res://core/cubeta_zona.tscn")
const ESCENA_SALIDA := "res://core/seleccion_mundos.tscn"

const TEXTURA_SONIDO := preload("res://assets/UI/actividad/Volumen.png")
const TEXTURA_SILENCIO := preload("res://assets/UI/actividad/Mute.png")

const MONEDAS_POR_ACTIVIDAD := 10
const VIDAS_MAXIMAS := 4
const TEXTURAS_VIDAS := [
	preload("res://assets/UI/actividad/Vidas0.png"),
	preload("res://assets/UI/actividad/Vidas1.png"),
	preload("res://assets/UI/actividad/Vidas2.png"),
	preload("res://assets/UI/actividad/Vidas3.png"),
	preload("res://assets/UI/actividad/Vidas4.png"),
]

@export var banco_palabras: WordBank
@export var palabras_por_ronda: int = 8
@export var fondo: Texture2D

@onready var zona_cubetas: HBoxContainer = $ZonaCubetas
@onready var zona_tarjetas: HFlowContainer = $ZonaTarjetas
@onready var barra_vidas: TextureRect = $BarraVidas
@onready var imagen_fondo: TextureRect = $Fondo
@onready var boton_sonido: TextureButton = $BotonSonido
@onready var etiqueta_monedas: Label = $ContadorMonedas/Cantidad
@onready var etiqueta_estrellas: Label = $ContadorEstrellas/Cantidad
@onready var ventana: Control = $Ventana
@onready var ventana_titulo: Label = $Ventana/Cuadro/Contenido/Titulo
@onready var ventana_detalle: Label = $Ventana/Cuadro/Contenido/Detalle
@onready var boton_primario: Button = $Ventana/Cuadro/Contenido/Botones/BotonPrimario
@onready var boton_secundario: Button = $Ventana/Cuadro/Contenido/Botones/BotonSecundario

var total_palabras: int = 0
var aciertos: int = 0
var vidas: int = VIDAS_MAXIMAS
var terminada: bool = false
var ventana_actual: Ventana = Ventana.PAUSA

func _ready() -> void:
	if fondo:
		imagen_fondo.texture = fondo
	ventana.hide()
	actualizar_contadores()
	actualizar_boton_sonido()
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
	vidas = VIDAS_MAXIMAS
	terminada = false
	actualizar_barra_vidas()

func crear_cubetas() -> void:
	for categoria in banco_palabras.categorias:
		var cubeta := ESCENA_CUBETA.instantiate()
		cubeta.etiqueta_categoria = categoria.etiqueta
		cubeta.imagen = categoria.imagen_contenedor
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
		tarjeta.textura = buscar_textura(dato["palabra"])
		zona_tarjetas.add_child(tarjeta)

func buscar_textura(palabra: String) -> Texture2D:
	if banco_palabras.carpeta_imagenes == "":
		return null
	var ruta := banco_palabras.carpeta_imagenes.path_join(palabra + ".png")
	if ResourceLoader.exists(ruta):
		return load(ruta)
	return null

func _on_palabra_soltada(es_correcta: bool, _tarjeta: PalabraCard) -> void:
	if terminada:
		return
	if es_correcta:
		aciertos += 1
		if aciertos >= total_palabras:
			completar_actividad()
	else:
		perder_vida()

func perder_vida() -> void:
	vidas = max(vidas - 1, 0)
	actualizar_barra_vidas()
	if vidas == 0:
		perder_actividad()

func actualizar_barra_vidas() -> void:
	barra_vidas.texture = TEXTURAS_VIDAS[vidas]

func actualizar_contadores() -> void:
	etiqueta_monedas.text = str(GameManager.coins)
	etiqueta_estrellas.text = str(GameManager.stars)

func bloquear_tarjetas() -> void:
	for tarjeta in zona_tarjetas.get_children():
		tarjeta.mouse_filter = Control.MOUSE_FILTER_IGNORE

func calcular_estrellas() -> int:
	if vidas == VIDAS_MAXIMAS:
		return 3
	if vidas >= 2:
		return 2
	return 1

func completar_actividad() -> void:
	terminada = true
	var estrellas := calcular_estrellas()
	var id_mundo := GameManager.current_world
	var primera_vez := id_mundo != "" and not GameManager.mundos_completados.has(id_mundo)
	GameManager.add_coins(MONEDAS_POR_ACTIVIDAD)
	if id_mundo != "":
		GameManager.completar_mundo(id_mundo, estrellas)
	actualizar_contadores()
	await get_tree().create_timer(0.6).timeout
	var detalle := "Aciertos: %d de %d\nMonedas: +%d\nEstrellas: %d de 3" % [aciertos, total_palabras, MONEDAS_POR_ACTIVIDAD, estrellas]
	if primera_vez and GameManager.desbloquea_siguiente(id_mundo):
		detalle += "\nNuevo mundo desbloqueado"
	mostrar_ventana(Ventana.GANAR, "Muy bien!", detalle, "Continuar", "Repetir")

func perder_actividad() -> void:
	terminada = true
	bloquear_tarjetas()
	await get_tree().create_timer(0.6).timeout
	var detalle := "Aciertos: %d de %d\nIntentalo otra vez" % [aciertos, total_palabras]
	mostrar_ventana(Ventana.PERDER, "Sin vidas", detalle, "Repetir", "Salir")

func mostrar_ventana(tipo: Ventana, titulo: String, detalle: String, texto_primario: String, texto_secundario: String) -> void:
	ventana_actual = tipo
	ventana_titulo.text = titulo
	ventana_detalle.text = detalle
	ventana_detalle.visible = detalle != ""
	boton_primario.text = texto_primario
	boton_secundario.text = texto_secundario
	ventana.show()

func reanudar() -> void:
	get_tree().paused = false
	ventana.hide()

func reiniciar() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()

func salir() -> void:
	get_tree().paused = false
	GameManager.goto_scene(ESCENA_SALIDA)

func actualizar_boton_sonido() -> void:
	if GameManager.sonido_silenciado:
		boton_sonido.texture_normal = TEXTURA_SILENCIO
	else:
		boton_sonido.texture_normal = TEXTURA_SONIDO

func _on_boton_pausa_pressed() -> void:
	if terminada:
		return
	get_tree().paused = true
	mostrar_ventana(Ventana.PAUSA, "Pausa", "", "Continuar", "Salir")

func _on_boton_sonido_pressed() -> void:
	GameManager.set_sonido_silenciado(not GameManager.sonido_silenciado)
	actualizar_boton_sonido()

func _on_boton_primario_pressed() -> void:
	match ventana_actual:
		Ventana.PAUSA:
			reanudar()
		Ventana.GANAR:
			salir()
		Ventana.PERDER:
			reiniciar()

func _on_boton_secundario_pressed() -> void:
	match ventana_actual:
		Ventana.PAUSA:
			salir()
		Ventana.GANAR:
			reiniciar()
		Ventana.PERDER:
			salir()
