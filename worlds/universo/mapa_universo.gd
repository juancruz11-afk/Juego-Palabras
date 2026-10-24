extends MundoIntro

@export var radio_lupa: float = 150.0

@onready var oscuridad: ColorRect = $CapaPersonajes/Oscuridad
@onready var lupa: Sprite2D = $CapaPersonajes/Telescopio

func _ready() -> void:
	super()
	var mat := oscuridad.material as ShaderMaterial
	mat.set_shader_parameter("radio", radio_lupa)

func _process(_delta: float) -> void:
	var pos := get_local_mouse_position()
	lupa.position = pos
	var mat := oscuridad.material as ShaderMaterial
	mat.set_shader_parameter("centro", pos)