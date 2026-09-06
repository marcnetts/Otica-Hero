extends Control

@export var txtMaiorPontuacao: RichTextLabel

func _ready():
	if txtMaiorPontuacao:
		txtMaiorPontuacao.text = "%04d" % VarGlobais.high_score

func _on_button_pregame_pressed() -> void:
	get_tree().change_scene_to_file("res://screen_pregame.tscn")

func _on_button_start_pressed() -> void:
	get_tree().change_scene_to_file("res://screen_game.tscn")

func _on_button_credits_pressed() -> void:
	get_tree().change_scene_to_file("res://screen_credits.tscn")
