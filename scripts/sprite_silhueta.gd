extends Sprite2D

@export var speed: float = 480.0
@export var bob_amplitude: float = 10.0
@export var bob_frequency: float = 5.0

var time_passed: float = 0.0
var posicaoInicialY: float
var posicaoEsquerda = true
var multiplicPosicaoEsquerda: int

func _ready() -> void:
	posicaoInicialY = position.y
	multiplicPosicaoEsquerda = 1 if posicaoEsquerda else -1
	flip_h = !posicaoEsquerda

func _process(delta: float):
	time_passed += delta
	
	# sin() é magia demais
	position.x += speed * delta * multiplicPosicaoEsquerda
	position.y = posicaoInicialY + sin(time_passed * bob_frequency) * bob_amplitude
	
	#if (posicaoEsquerda and position.x > get_viewport().get_visible_rect().size.x + get_rect().size.x / 2) or !posicaoEsquerda and position:
	if (posicaoEsquerda and position.x > get_viewport().get_visible_rect().size.x + get_rect().size.x / 2) or (!posicaoEsquerda and position.x < 0 - get_rect().size.x / 2):
		print('bye!')
		queue_free()
