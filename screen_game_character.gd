extends CharacterBody2D

@export var bop_distance := 20.0
@export var bop_stretch := 3.5
@export var bop_duration := 0.12

@export var characterSprite : Sprite2D

var original_position : Vector2
var original_scale : Vector2
var bop_tween : Tween

func _ready():
	original_position = position
	original_scale = scale

func _process(delta):

	var dir := Vector2.ZERO

	if Input.is_action_just_pressed("ui_left"):
		dir = Vector2.LEFT

	elif Input.is_action_just_pressed("ui_right"):
		dir = Vector2.RIGHT

	elif Input.is_action_just_pressed("ui_up"):
		dir = Vector2.UP

	elif Input.is_action_just_pressed("ui_down"):
		dir = Vector2.DOWN

	if dir != Vector2.ZERO:
		bop(dir)

func bop(direction: Vector2):
	#print(direction)

	if bop_tween:
		bop_tween.kill()

	position = original_position
	scale = original_scale

	var tween = create_tween()

	# Move slightly toward direction
	tween.tween_property(
		self,
		"position",
		original_position + direction * bop_distance,
		bop_duration
	).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)

	# Stretch depending on direction
	var target_scale = original_scale

	#if direction.x != 0:
		#target_scale = Vector2(
			#original_scale.x * bop_stretch,
			#original_scale.y / bop_stretch
		#)
	#else:
		#target_scale = Vector2(
			#original_scale.x / bop_stretch,
			#original_scale.y * bop_stretch
		#)

	tween.parallel().tween_property(
		self,
		"scale",
		target_scale,
		bop_duration
	).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)

	# Return to normal
	tween.tween_property(
		self,
		"position",
		original_position,
		bop_duration * 1.8
	).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)

	tween.parallel().tween_property(
		self,
		"scale",
		original_scale,
		bop_duration * 1.8
	).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
