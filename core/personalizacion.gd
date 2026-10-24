extends Control

@onready var personaje_preview = $HBoxContainer/LadoPersonaje/PersonajePreview

# Referencias a tus 4 grillas
@onready var grilla_cabello = $HBoxContainer/LadoBotones/GrillaCabello
@onready var grilla_piel = $HBoxContainer/LadoBotones/GrillaPiel
@onready var grilla_ropa = $HBoxContainer/LadoBotones/GrillaRopa
@onready var grilla_mochila = $HBoxContainer/LadoBotones/GrillaMochila
@onready var fondo_popup = $FondoPopup

# Al iniciar la escena, mostramos el cabello por defecto
func _ready():
	mostrar_grilla(grilla_piel)

func aplicar_item(ruta_imagen: String):
	var nueva_textura = load(ruta_imagen)
	if nueva_textura:
		personaje_preview.texture = nueva_textura

# Oculta todas y muestra solo la que le pidas
func mostrar_grilla(grilla_activa: Control):
	grilla_cabello.hide()
	grilla_piel.hide()
	grilla_ropa.hide()
	grilla_mochila.hide()
	grilla_activa.show()

func _on_regresar_button_pressed():
	GameManager.goto_scene("res://core/world_map.tscn")
	
# Esta es la función a la que conectaste TODOS los botones oscuros
func _on_item_bloqueado_pressed():
	fondo_popup.show()
	
# --- SEÑALES DE LAS PESTAÑAS ---

func _on_button_pressed(): # Botón COLOR (Piel)
	mostrar_grilla(grilla_piel)

func _on_button_2_pressed(): # Botón CABELLO
	mostrar_grilla(grilla_cabello)

func _on_button_3_pressed(): # Botón ROPA
	mostrar_grilla(grilla_ropa)

func _on_button_4_pressed(): # Botón MOCHILA
	mostrar_grilla(grilla_mochila)

# --- SECCIÓN CABELLO ---

func _on_cabello_1_pressed():
	aplicar_item("res://assets/Personalización/Sección - Cabello/3.png")

func _on_cabello_2_pressed():
	aplicar_item("res://assets/Personalización/Amanda 1.png")

func _on_cabello_3_pressed():
	aplicar_item("res://assets/Personalización/Sección - Cabello/2.png")
	
func _on_cabello_4_pressed():
	aplicar_item("res://assets/Personalización/Sección - Cabello/1.png")

# --- SECCIÓN ROPA ---

func _on_ropa_1_pressed():
	aplicar_item("res://assets/Personalización/Amanda 1.png")

func _on_ropa_2_pressed():
	aplicar_item("res://assets/Personalización/Sección - Ropa/Amanda 3.png")

func _on_ropa_3_pressed():
	aplicar_item("res://assets/Personalización/Sección - Ropa/Amanda 4.png")

func _on_ropa_4_pressed():
	aplicar_item("res://assets/Personalización/Sección - Ropa/Amanda 1.png")
	
func _on_ropa_5_pressed():
	aplicar_item("res://assets/Personalización/Sección - Ropa/Amanda 2.png")

# --- SECCIÓN MOCHILA ---

func _on_mochila_1_pressed():
	aplicar_item("res://assets/Personalización/Amanda 1.png")

func _on_mochila_2_pressed():
	aplicar_item("res://assets/Personalización/Sección - Mochila/1.png")

func _on_mochila_3_pressed():
	aplicar_item("res://assets/Personalización/Sección - Mochila/2.png")
	
func _on_mochila_4_pressed():
	# Modifica el nombre de la imagen 4 si es diferente en tu carpeta
	aplicar_item("res://assets/Personalización/Sección - Mochila/3.png")

# --- SECCIÓN PIEL (COLOR) ---

func _on_piel_1_pressed():
	aplicar_item("res://assets/Personalización/Sección - Piel/Amanda Piel 1.png")

func _on_piel_2_pressed():
	aplicar_item("res://assets/Personalización/Amanda 1.png")

func _on_piel_3_pressed():
	aplicar_item("res://assets/Personalización/Sección - Piel/Amanda piel 3.png")
	
func _on_piel_4_pressed():
	# Ajusta el nombre si tienes otra variación guardada
	aplicar_item("res://assets/Personalización/Sección - Piel/Amanda piel 4.png")
	
# --- SEÑALES DEL POPUP ---

func _on_boton_ir_tienda_pressed(): # Reemplaza con el nombre real de tu señal
	# Vi en tu árbol de archivos que tu tienda está en core/tienda.tscn
	GameManager.goto_scene("res://core/tienda.tscn") 

func _on_boton_cancelar_pressed(): # Reemplaza con el nombre real de tu señal
	fondo_popup.hide()
