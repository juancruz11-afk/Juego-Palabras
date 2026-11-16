extends Control

const ESCENAS_MUNDOS := [
	"res://worlds/bosque/mapa_bosque.tscn",
	"res://worlds/playa_letras/mapa_playa.tscn",
	"res://worlds/desierto/mapa_desierto.tscn",
	"res://worlds/volcan/mapa_volcan.tscn",
	"res://worlds/universo/mapa_universo.tscn",
]

@export var texturas_mundos: Array[Texture2D] = []
@export var texturas_bloqueadas: Array[Texture2D] = []

var indice_actual: int = 0

func _ready():
	indice_actual = clamp(GameManager.indice_carrusel, 0, texturas_mundos.size() - 1)
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
	if not GameManager.mundo_desbloqueado(indice_actual):
		return
	if indice_actual >= ESCENAS_MUNDOS.size():
		return
	GameManager.current_world = GameManager.ORDEN_MUNDOS[indice_actual]
	GameManager.goto_scene(ESCENAS_MUNDOS[indice_actual])

func textura_del_mundo(indice: int) -> Texture2D:
	var bloqueado := not GameManager.mundo_desbloqueado(indice)
	if bloqueado and indice < texturas_bloqueadas.size():
		return texturas_bloqueadas[indice]
	return texturas_mundos[indice]

func actualizar_mundo():
	GameManager.indice_carrusel = indice_actual
	$MBosque.texture_normal = textura_del_mundo(indice_actual)
	$FlechaL.visible = indice_actual > 0
	$FlechaR.visible = indice_actual < texturas_mundos.size() - 1
