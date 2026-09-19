extends Panel
class_name PalabraCard

@export var palabra: String = ""
@export var categoria_correcta: String = ""

@onready var etiqueta: Label = $Etiqueta

func _ready() -> void:
	etiqueta.text = palabra

func _get_drag_data(_at_position: Vector2) -> Variant:
	var preview := Panel.new()
	var preview_label := Label.new()
	preview_label.text = palabra
	preview.add_child(preview_label)
	preview.custom_minimum_size = size
	set_drag_preview(preview)

	modulate.a = 0.4

	return {
		"origen": self,
		"palabra": palabra,
		"categoria_correcta": categoria_correcta
	}

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