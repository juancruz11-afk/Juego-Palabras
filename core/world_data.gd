extends Resource
class_name WorldData

@export var id_mundo: String
@export var nombre_mundo: String
@export var ubicacion: String
@export var nombre_personaje: String
@export var texto_intro: String
@export var trucos: Array[String] = []
@export var bancos_palabras: Array[WordBank] = []
@export var palabras_reto_final: Array[String] = []
@export var monedas_recompensa: int
@export var skin_recompensa: String