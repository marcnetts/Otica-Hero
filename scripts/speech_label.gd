extends Sprite2D

#func show_value(value, travel, duration, spread, crit=false):
	#text = value
	#var movement = travel.rotated(randf_range(-spread/2, spread/2))
	#rect_pivot_offset = rect_size / 2

func _ready():
	# Create a tween for animations
	var tween = create_tween()
	
	# Animate movement: move up by 50 pixels over 1 second
	tween.tween_property(self, "position", position + Vector2(0, -50), 1.0)
	
	# Animate fade out: modulate alpha to 0 over 1 second
	tween.parallel().tween_property(self, "modulate:a", 0, 1.0)
	
	# Destroy the node when finished
	tween.tween_callback(queue_free)

#func set_text(value: String, color: Color = Color.WHITE):
	#text = value
	#modulate = color
