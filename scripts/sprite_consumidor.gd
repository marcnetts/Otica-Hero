extends Sprite2D

@export var posicaoDespawnX = 505.0
@export var speed: float = 200.0
@export var bob_amplitude: float = 3.0
@export var bob_frequency: float = 2.0

var time_passed: float = 0.0
var posicaoInicialY: float
var checaTempo = true

func _ready() -> void:
	posicaoInicialY = position.y

func _process(delta: float):
	if checaTempo:
		if (position.x >= posicaoDespawnX):
			checaTempo = false
			var tween = create_tween()
			tween.tween_property(self, "modulate:a", 0.0, 0.8)
			tween.chain().tween_callback(queue_free)
		else:
			time_passed += delta
			
			# sin() é magia demais
			position.x += speed * delta
			position.y = posicaoInicialY + sin(time_passed * bob_frequency) * bob_amplitude
	
