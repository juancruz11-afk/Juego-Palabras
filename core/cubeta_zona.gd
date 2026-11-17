extends Panel
class_name CubetaZona

signal palabra_soltada(es_correcta, tarjeta)

const TAMANO_CON_IMAGEN := Vector2(206, 180)
const TAMANO_SIN_IMAGEN := Vector2(200, 190)

@export var etiqueta_categoria: String = ""

var imagen: Texture2D

# Ancho maximo disponible cuando hay muchos contenedores en pantalla
var ancho_maximo: float = 0.0

@onready var titulo: Label = $Diseno/Titulo
@onready var contenedor: VBoxContainer = $Diseno/Contenedor
@onready var diseno: VBoxContainer = $Diseno
@onready var imagen_cubeta: TextureRect = $Imagen

func _ready() -> void:
	titulo.text = etiqueta_categoria
	var tamano := TAMANO_SIN_IMAGEN
	if imagen:
		imagen_cubeta.texture = imagen
		diseno.hide()
		tamano = TAMANO_CON_IMAGEN
		add_theme_stylebox_override("panel", StyleBoxEmpty.new())
	else:
		add_theme_stylebox_override("panel", crear_estilo_sin_imagen())
		titulo.size_flags_vertical = Control.SIZE_EXPAND_FILL
		titulo.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		titulo.add_theme_font_size_override("font_size", 56)
		titulo.add_theme_color_override("font_color", Color(0.45, 0.25, 0.05))
		contenedor.hide()
	if ancho_maximo > 0.0:
		tamano.x = min(tamano.x, ancho_maximo)
	custom_minimum_size = tamano

func crear_estilo_sin_imagen() -> StyleBoxFlat:
	var estilo := StyleBoxFlat.new()
	estilo.bg_color = Color(0.99, 0.93, 0.74)
	estilo.border_color = Color(0.6, 0.38, 0.05)
	estilo.set_border_width_all(5)
	estilo.set_corner_radius_all(22)
	return estilo

func _can_drop_data(_posicion: Vector2, datos: Variant) -> bool:
	return typeof(datos) == TYPE_DICTIONARY and datos.has("categoria_correcta")

func _drop_data(_posicion: Vector2, datos: Variant) -> void:
	var tarjeta: PalabraCard = datos["origen"]
	var es_correcta: bool = datos["categoria_correcta"] == etiqueta_categoria

	if es_correcta:
		tarjeta.desaparecer()
	else:
		tarjeta.mostrar_incorrecto()

	palabra_soltada.emit(es_correcta, tarjeta)
