extends Area2D

@onready var area = $"."
@onready var text = $Label
@onready var yap = $Yapper
@onready var animations = $AnimatedSprite2D
@onready var SpeechNoise = $Talk

var playerdetected
var player_nearby: bool = false
var haveSpoke = false

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
		if haveSpoke:
			var yapper: int = randi_range(1,5)
			if yapper == 1:
				Speak("Heya! This area is under construction.")
			elif yapper == 2:
				Speak("I hope you're doing alright.")
			elif yapper == 3:
				Speak("I appreciate the concerns about me but I am fine.")
			elif yapper == 4:
				Speak("Me coming along? I'll think about it.")
			elif yapper == 5:
				Speak("Once you leave the lab I will forget about the conversation we had.")
		else:
			haveSpoke = true
			if global.character == 0:
				Speak("Hey my best friend, how are you doing?")
			if global.character == 1:
				Speak("noox has told me about you, you're... him...")
			if global.character == 2:
				Speak("Oh, Guy Darkheart. It's nice to see you again.")
			if global.character == 3:
				Speak("I believe we haven't met before. My name is Glassman. Nice to meet you!")

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
