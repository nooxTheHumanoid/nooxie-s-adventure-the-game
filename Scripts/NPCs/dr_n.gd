extends Area2D

@onready var area = $"."
@onready var text = $Label
@onready var yap = $Yapper
@onready var animations = $AnimatedSprite2D
@onready var SpeechNoise = $Talk

var playerdetected
var player_nearby: bool = false

func _ready() -> void:
	text.visible = false
	

func _process(_delta: float) -> void:
	if player_nearby:
		if Input.is_action_just_pressed("interact"):
			interact()
	if playerdetected != null:
		if playerdetected.position.x < global_position.x:
			animations.flip_h = true
		else:
			animations.flip_h = false
		

func interact():
	if yap.visible_characters == 0:
		var yapper: int = randi_range(1,3)
		if yapper == 1:
			Speak("I love yapping")
		elif yapper == 2:
			Speak("Insert DrN yapping about something that people will like")
		elif yapper == 3:
			if global.censor_swearT:
				Speak("Oh yeah, yapping")
			else:
				Speak("Fuck yeah, yapping")

func Speak(yaptext):
	yap.visible_characters = 0
	yap.text = yaptext
	var textBuildDuration = yap.get_total_character_count() * 0.075
	var tween = create_tween()
	tween.tween_property(yap,"visible_characters",yap.get_total_character_count(),textBuildDuration)
	#if !global.VoiceActing && global.SFX_Enabled:
	if global.SFX_Enabled:
		SpeechNoise.play()
	await get_tree().create_timer(textBuildDuration+3).timeout
	yap.visible_characters = 0

func _on_body_shape_entered(_body_rid: RID, body: Node2D, _body_shape_index: int, _local_shape_index: int) -> void:
	text.visible = true
	player_nearby = true
	playerdetected = body
	
func _on_body_shape_exited(_body_rid: RID, body: Node2D, _body_shape_index: int, _local_shape_index: int) -> void:
	text.visible = false
	player_nearby = false
	playerdetected = body
