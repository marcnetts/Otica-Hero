extends Control

@export
var txt_direction_label: RichTextLabel
@export
var txt_score_label: RichTextLabel
@export
var txt_time_label: RichTextLabel
@export
var txt_time_timeout: RichTextLabel
@export
var txt_melhor_pontuacao: RichTextLabel
@export
var gameTimer: Timer
@export
var wrongMoveTimer: Timer
@export
var timer_pessoas_passando: Timer
@export
var audio_musica: AudioStreamPlayer
@export
var audio_apito: AudioStreamPlayer
@export
var button_sair: Button

@export
var score = 0
@export
var tempo = 6000

@export
var directions_to_score = {
	"↑": {
		"vector": Vector2.UP,
		"sprite": load("res://images/character/character-up.png"),
	},
	"←": {
		"vector": Vector2.LEFT,
		"sprite": load("res://images/character/character-left.png"),
	},
	"→": {
		"vector": Vector2.RIGHT,
		"sprite": load("res://images/character/character-right.png"),
	},
	"↓": {
		"vector": Vector2.DOWN,
		"sprite": load("res://images/character/character-down.png"),
	},
}

@export
var current_direction_to_score = "↓"

@export var character: CharacterBody2D
@export var characterSprite: Sprite2D

var comboJogadasBoas: int
var coresBoasTxt = ['#18ff03', '#4203ff', '#4203ff', '#ff03ff']
var txtJogadasBoas = ['Boa!', 'Uuia!', 'Nicee', 'Oloco!', '<3', 'Rapaaiiz', 'Fera!', 'Su-ce-sso!']

var floating_text_scene = preload("res://appearing_text_label.tscn")
var sprite_silhueta = preload("res://styles/sprite_silhueta.tscn")

var posicaoAcimaJogador: Vector2
var posicaoAcimaCaixaSom = Vector2(697, 351)
var pessoasPassando: int

func _ready():
	gameTimer.connect("timeout", _on_gameTimer_timeout)
	gameTimer.start()
	posicaoAcimaJogador = Vector2(character.position.x + characterSprite.position.x, 340)
	audio_musica.play()
	timer_pessoas_passando.connect("timeout", _on_timer_pessoas_passando_timeout)

func _on_gameTimer_timeout():
	tempo -= 1
	txt_time_label.text = "%02d" % tempo
	if(tempo <= 0):
		pararJogo()

func pararJogo():
	gameTimer.stop()
	txt_time_timeout.show()
	audio_apito.play()
	if VarGlobais.high_score == score:
		txt_score_label.text = '[color=00ff00]' + txt_score_label.text + '[/color]'
		txt_melhor_pontuacao.show()
	
	#diminuuui audio
	var tween = create_tween().tween_property(audio_musica, "volume_db", -80.0, 2.0)
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_IN)
	await tween.finished
	audio_musica.volume_db = 0.0
	audio_musica.stop()
	await get_tree().create_timer(2.0).timeout
	button_sair._on_btn_title_screen_pressed()

func _process(delta):
	if(tempo > 0 && wrongMoveTimer.is_stopped()):
		var vetor_personagem := ''

		if Input.is_action_just_pressed("move_up"):
			vetor_personagem = '↑'
		elif Input.is_action_just_pressed("move_left"):
			vetor_personagem = '←'
		elif Input.is_action_just_pressed("move_right"):
			vetor_personagem = '→'
		elif Input.is_action_just_pressed("move_down"):
			vetor_personagem = '↓'

		if vetor_personagem != '':
			if directions_to_score[vetor_personagem].vector == directions_to_score[current_direction_to_score].vector:
				addScore()
			elif vetor_personagem != '':
				wrongMove()
			
			if wrongMoveTimer.is_stopped():
				characterSprite.texture = directions_to_score[vetor_personagem].sprite
		
	if(tempo <= 0):
		pass
		#//terminar mais aqui

func addScore():
	score += 10 + (5 if comboJogadasBoas >= 10 else 0)
	VarGlobais.high_score = max(score, VarGlobais.high_score)
	txt_score_label.text = "%04d" % score
	novaDirecao()
	comboJogadasBoas += 1
	show_text_above_character('✓', posicaoAcimaCaixaSom, false, 40)
	if(comboJogadasBoas > 10):
		show_text_above_character(txtJogadasBoas.pick_random(), posicaoAcimaJogador)

func wrongMove():
	wrongMoveTimer.start()
	show_text_above_character("Whoops!", posicaoAcimaJogador, true)
	#animação aqui
	comboJogadasBoas = 0
	characterSprite.texture = load("res://images/character/character-error.png")

func show_text_above_character(innerText: String, position: Vector2, wrongMove = false, fontSize = 28):
	var text = floating_text_scene.instantiate()
	text.add_theme_font_size_override("normal_font_size", fontSize)
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

func _on_timer_pessoas_passando_timeout():
	if tempo > 0 and randf() < 0.10:
		var posicaoEsquerda = randf() > 0.5
		var npcAndando = sprite_silhueta.instantiate()
		npcAndando.position = Vector2(-100, get_viewport_rect().size.y - 110)
		add_child(npcAndando)
