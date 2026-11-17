extends Node

signal progreso_cambiado

const ORDEN_MUNDOS := [
	"bosque_palabras",
	"playa_letras",
	"desierto_catavina",
	"volcan_retos",
	"universo_final",
]

var current_world: String = ""
var player_name: String = ""
var coins: int = 0
var stars: int = 0
var sonido_silenciado: bool = false
var indice_carrusel: int = 0

# Carpeta con las poses del avatar del jugador (pose1.png a pose5.png)
var carpeta_avatar: String = "res://assets/avatar/predeterminado"

# Mejor cantidad de estrellas obtenida en cada mundo completado
var mundos_completados: Dictionary = {}

func goto_scene(path: String) -> void:
	get_tree().change_scene_to_file(path)

func add_coins(amount: int) -> void:
	coins += amount
	progreso_cambiado.emit()

func add_stars(amount: int) -> void:
	stars += amount
	progreso_cambiado.emit()

func set_sonido_silenciado(valor: bool) -> void:
	sonido_silenciado = valor
	AudioServer.set_bus_mute(0, valor)

func set_player_name(new_name: String) -> void:
	player_name = new_name

func textura_avatar(pose: int) -> Texture2D:
	var ruta := carpeta_avatar.path_join("pose%d.png" % pose)
	if ResourceLoader.exists(ruta):
		return load(ruta)
	return null

func mundo_desbloqueado(indice: int) -> bool:
	if indice <= 0:
		return true
	if indice >= ORDEN_MUNDOS.size():
		return false
	return mundos_completados.has(ORDEN_MUNDOS[indice - 1])

# Registra el mundo como completado y devuelve las estrellas nuevas ganadas
func completar_mundo(id_mundo: String, estrellas: int) -> int:
	var anteriores: int = mundos_completados.get(id_mundo, 0)
	var nuevas: int = max(estrellas - anteriores, 0)
	mundos_completados[id_mundo] = max(estrellas, anteriores)
	if nuevas > 0:
		add_stars(nuevas)
	return nuevas

func desbloquea_siguiente(id_mundo: String) -> bool:
	var indice := ORDEN_MUNDOS.find(id_mundo)
	return indice >= 0 and indice < ORDEN_MUNDOS.size() - 1
