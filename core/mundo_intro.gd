extends Control
class_name MundoIntro

const CARACTERES_POR_SEGUNDO := 40.0

@export var datos_mundo: WorldData
@export var escena_actividad: String = ""

@onready var panel_intro: Panel = $PanelIntro
@onready var texto_intro: Label = $PanelIntro/TextoIntro
@onready var indicador: Label = $PanelIntro/Indicador

var paginas: Array[String] = []
var pagina_actual: int = 0
var animacion_texto: Tween

func _ready() -> void:
	if datos_mundo:
		paginas.append(datos_mundo.texto_intro)
		for truco in datos_mundo.trucos:
			paginas.append(truco)
	else:
		paginas.append(texto_intro.text)
	panel_intro.gui_input.connect(_on_panel_intro_gui_input)
	mostrar_pagina(0)

func mostrar_pagina(indice: int) -> void:
	pagina_actual = indice
	texto_intro.text = paginas[indice]
	texto_intro.visible_ratio = 0.0
	indicador.hide()
	var duracion: float = max(paginas[indice].length() / CARACTERES_POR_SEGUNDO, 0.2)
	animacion_texto = create_tween()
	animacion_texto.tween_property(texto_intro, "visible_ratio", 1.0, duracion)
	animacion_texto.tween_callback(terminar_pagina)

func terminar_pagina() -> void:
	texto_intro.visible_ratio = 1.0
	var hay_mas := pagina_actual < paginas.size() - 1
	indicador.text = "Clic para continuar (%d de %d)" % [pagina_actual + 1, paginas.size()]
	indicador.visible = hay_mas

# Un clic completa el texto en curso y el siguiente pasa de pagina
func avanzar() -> void:
	if animacion_texto and animacion_texto.is_running():
		animacion_texto.kill()
		terminar_pagina()
		return
	if pagina_actual < paginas.size() - 1:
		mostrar_pagina(pagina_actual + 1)

func _on_panel_intro_gui_input(evento: InputEvent) -> void:
	if evento is InputEventMouseButton and evento.pressed and evento.button_index == MOUSE_BUTTON_LEFT:
		avanzar()

func _on_boton_jugar_pressed() -> void:
	if escena_actividad != "":
		GameManager.goto_scene(escena_actividad)

func _on_boton_regresar_pressed() -> void:
	GameManager.goto_scene("res://core/seleccion_mundos.tscn")
