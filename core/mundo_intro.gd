extends Control
class_name MundoIntro

@export var datos_mundo: WorldData
@export var escena_actividad: String = ""

@onready var texto_intro: Label = $PanelIntro/TextoIntro

func _ready() -> void:
	if datos_mundo:
		texto_intro.text = datos_mundo.texto_intro

func _on_boton_jugar_pressed() -> void:
	if escena_actividad != "":
		GameManager.goto_scene(escena_actividad)

func _on_boton_regresar_pressed() -> void:
	GameManager.goto_scene("res://core/seleccion_mundos.tscn")