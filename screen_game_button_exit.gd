extends Control

func _on_btn_title_screen_pressed() -> void:
	get_tree().change_scene_to_file("res://screen_title.tscn")
