extends Panel
class_name PalabraCard

const TAMANO_CON_IMAGEN := Vector2(168, 43)

@export var palabra: String = ""
@export var categoria_correcta: String = ""

var textura: Texture2D

@onready var etiqueta: Label = $Etiqueta
@onready var imagen: TextureRect = $Imagen

func _ready() -> void:
	etiqueta.text = palabra
	if textura:
		imagen.texture = textura
		etiqueta.hide()
		custom_minimum_size = TAMANO_CON_IMAGEN
		add_theme_stylebox_override("panel", StyleBoxEmpty.new())

func _get_drag_data(_at_position: Vector2) -> Variant:
	set_drag_preview(crear_vista_arrastre())
	modulate.a = 0.4

	return {
		"origen": self,
		"palabra": palabra,
		"categoria_correcta": categoria_correcta
	}

func crear_vista_arrastre() -> Control:
	if textura:
		var vista := TextureRect.new()
		vista.texture = textura
		vista.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		vista.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		vista.size = size
		return vista
	var preview := Panel.new()
	var preview_label := Label.new()
	preview_label.text = palabra
	preview.add_child(preview_label)
	preview.custom_minimum_size = size
	return preview

func _notification(what: int) -> void:
	if what == NOTIFICATION_DRAG_END:
		modulate.a = 1.0

func mostrar_correcto() -> void:
	var tween := create_tween()
	modulate = Color(0.6, 1.0, 0.6)
	tween.tween_property(self, "modulate", Color.WHITE, 0.4)

func mostrar_incorrecto() -> void:
	var posicion_original := position
	var tween := create_tween()
	modulate = Color(1.0, 0.6, 0.6)
	tween.tween_property(self, "position", posicion_original + Vector2(8, 0), 0.05)
	tween.tween_property(self, "position", posicion_original - Vector2(8, 0), 0.05)
	tween.tween_property(self, "position", posicion_original, 0.05)
	tween.parallel().tween_property(self, "modulate", Color.WHITE, 0.3)

func desaparecer() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	pivot_offset = size / 2.0
	modulate = Color(0.6, 1.0, 0.6)
	var tween := create_tween()
	tween.tween_property(self, "scale", Vector2.ZERO, 0.3)
	tween.parallel().tween_property(self, "modulate:a", 0.0, 0.3)
	tween.tween_callback(queue_free)
