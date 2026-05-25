extends Node2D

@onready var TalkText = $DioText
@onready var Option1 = $Button
@onready var Option2 = $Button2
@onready var Option3 = $Button3
@onready var next = $NextButton
# Character things
@onready var angry = $CharAngry
@onready var normal = $CharNorm
@onready var happy = $CharHappy
@onready var scared = $CharScared

var path = 0 #this ain't good for long stories.

func _ready() -> void:
	path = 0
	TalkText.text = "Objective: Rizz up noox nooxie nooxTheHumanoid NX Noxious noxon noexion nooxious nooxin'"
	Option1.visible = false
	Option2.visible = false
	Option3.visible = false
	next.visible = true
	angry.visible = false
	normal.visible = false
	happy.visible = false
	scared.visible = false

func _on_next_button_pressed() -> void:
	if path == 4:
		TalkText.text = "You were dropkicked and found out your head is no longer attached to your neck."
		Option1.visible = false
		Option2.visible = false
		Option3.visible = false
		next.visible = false
		angry.visible = false
		normal.visible = false
		happy.visible = false
		scared.visible = false
	if path == 0:
		TalkText.text = "The fuck are you?"
		normal.visible = true
		Option1.visible = true
		Option2.visible = true
		Option3.visible = true
		next.visible = false
	if path == 1:
		path = 4
		TalkText.text = "DIE!"
		Option1.visible = false
		Option2.visible = false
		Option3.visible = false
		next.visible = true
		angry.visible = true
		normal.visible = false
		happy.visible = false
		scared.visible = false
	if path == 2:
		path = 4
		TalkText.text = "STAY AWAY FROM ME!"
		Option1.visible = false
		Option2.visible = false
		Option3.visible = false
		next.visible = true
		angry.visible = false
		normal.visible = false
		happy.visible = false
		scared.visible = true
	if path == 3:
		path = 4
		TalkText.text = "FUCKING DIE!"
		Option1.visible = false
		Option2.visible = false
		Option3.visible = false
		next.visible = true
		angry.visible = true
		normal.visible = false
		happy.visible = false
		scared.visible = false
	
	


func _on_button_3_pressed() -> void:
	if path == 0:
		path = 3
		TalkText.text = "Oh a human."
		normal.visible = false
		angry.visible = false
		happy.visible = true
		Option1.visible = false
		Option2.visible = false
		Option3.visible = false
		next.visible = true


func _on_button_2_pressed() -> void:
	if path == 0:
		path = 2
		TalkText.text = "AH! A WOMAN!"
		normal.visible = false
		angry.visible = false
		scared.visible = true
		Option1.visible = false
		Option2.visible = false
		Option3.visible = false
		next.visible = true


func _on_button_pressed() -> void:
	if path == 0:
		path = 1
		TalkText.text = "I'm not gay!"
		normal.visible = false
		angry.visible = true
		Option1.visible = false
		Option2.visible = false
		Option3.visible = false
		next.visible = true
