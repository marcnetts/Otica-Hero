extends Control

@export
var txt_direction_label: RichTextLabel
@export
var txt_score_label: RichTextLabel
@export
var txt_time_label: RichTextLabel
@export
var gameTimer: Timer
@export
var wrongMoveTimer: Timer
@export
var audio: AudioStreamPlayer

@export
var score = 0
@export
var tempo = 6000

@export
var directions_to_score = {
	"↑": Vector2.UP,
	"←": Vector2.LEFT,
	"→": Vector2.RIGHT,
	"↓": Vector2.DOWN,
}
@export
var current_direction_to_score = "↓"

@export var character: CharacterBody2D
@export var characterSprite: Sprite2D

var comboJogadasBoas: int
var coresBoasTxt = ['#18ff03', '#4203ff', '#4203ff', '#ff03ff']
var txtJogadasBoas = ['Boa!', 'Uuia!', 'Nicee', 'Oloco!', '<3', 'Rapaaiiz', 'Fera!', 'Su-ce-sso!']

var floating_text_scene = preload("res://appearing_text_label.tscn")

var posicaoAcimaJogador: Vector2
var posicaoAcimaCaixaSom = Vector2(697, 351)

func _ready():
	gameTimer.connect("timeout", _on_gameTimer_timeout)
	gameTimer.start()
	posicaoAcimaJogador = Vector2(character.position.x + characterSprite.position.x, 390)
	audio.play()

func _on_gameTimer_timeout():
	tempo -= 1
	txt_time_label.text = str(tempo)
	if(tempo <= 0):
		gameTimer.stop()
		audio.stop()

func _process(delta):
	if(tempo > 0 && wrongMoveTimer.is_stopped()):
		var vetor_personagem := Vector2.ZERO

		if Input.is_action_just_pressed("ui_left"):
			vetor_personagem = Vector2.LEFT

		elif Input.is_action_just_pressed("ui_right"):
			vetor_personagem = Vector2.RIGHT

		elif Input.is_action_just_pressed("ui_up"):
			vetor_personagem = Vector2.UP

		elif Input.is_action_just_pressed("ui_down"):
			vetor_personagem = Vector2.DOWN

		if vetor_personagem == directions_to_score[current_direction_to_score]:
			addScore()
		elif vetor_personagem != Vector2.ZERO:
			wrongMove()
	if(tempo <= 0):
		pass
		#//terminar mais aqui

func addScore():
	score += 10
	VarGlobais.high_score = max(score, VarGlobais.high_score)
	txt_score_label.text = "%04d" % score
	novaDirecao()
	comboJogadasBoas += 1
	show_text_above_character('✓', posicaoAcimaCaixaSom)
	if(comboJogadasBoas > 10):
		show_text_above_character(txtJogadasBoas.pick_random(), posicaoAcimaJogador)

func wrongMove():
	wrongMoveTimer.start()
	show_text_above_character("Whoops!", posicaoAcimaJogador, true)
	#animação aqui
	comboJogadasBoas = 0

func show_text_above_character(innerText: String, position: Vector2, wrongMove = false):
	var text = floating_text_scene.instantiate()
	text.global_position = position
	text.push_color(Color("Red") if wrongMove else Color(coresBoasTxt.pick_random()))
		
	text.add_text(innerText)
	get_tree().current_scene.add_child(text)
	print(character.position)
	print(text)

func novaDirecao():
	current_direction_to_score = dicionarioSemDadoFiltrado(directions_to_score, current_direction_to_score).keys().pick_random()
	txt_direction_label.text = current_direction_to_score
	
func dicionarioSemDadoFiltrado(dicionario_original: Dictionary, dadoexcluido: String):
	var filtered = {}

	for key in dicionario_original:
		if key != dadoexcluido:
			filtered[key] = dicionario_original[key]
	
	return filtered
