extends Sprite2D

@export var speed: float = 480.0
@export var bob_amplitude: float = 10.0
@export var bob_frequency: float = 5.0

var time_passed: float = 0.0
var posicaoInicialY: float

func _ready() -> void:
	posicaoInicialY = position.y

func _process(delta: float):
	time_passed += delta
	
	# sin() é magia demais
	position.x += speed * delta
	position.y = posicaoInicialY + sin(time_passed * bob_frequency) * bob_amplitude
	
	if position.x > get_viewport().get_visible_rect().size.x + get_rect().size.x / 2:
		queue_free()
