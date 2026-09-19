extends Panel
class_name CubetaZona

signal palabra_soltada(es_correcta, tarjeta)

@export var etiqueta_categoria: String = ""

@onready var titulo: Label = $Diseno/Titulo
@onready var contenedor: VBoxContainer = $Diseno/Contenedor

func _ready() -> void:
	titulo.text = etiqueta_categoria

func _can_drop_data(_posicion: Vector2, datos: Variant) -> bool:
	return typeof(datos) == TYPE_DICTIONARY and datos.has("categoria_correcta")

func _drop_data(_posicion: Vector2, datos: Variant) -> void:
	var tarjeta: PalabraCard = datos["origen"]
	var es_correcta: bool = datos["categoria_correcta"] == etiqueta_categoria

	if es_correcta:
		tarjeta.get_parent().remove_child(tarjeta)
		contenedor.add_child(tarjeta)
		tarjeta.mouse_filter = Control.MOUSE_FILTER_IGNORE
		tarjeta.mostrar_correcto()
	else:
		tarjeta.mostrar_incorrecto()

	palabra_soltada.emit(es_correcta, tarjeta)