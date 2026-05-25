extends Control
@onready var UserText = $User
@onready var LocationText = $Location
@onready var MentalState = $MentalState
@onready var MedicalText = $Medical
@onready var InjuryText = $InjuryInfo
@onready var EGCStrip = $Line2D
@export var hasHeartbeat = true
var medicalColor = true
var cricticalState = false
var injury = true
var timer = 0

func _ready() -> void:
	EGCStrip.visible = hasHeartbeat
	pass
	
func _process(_delta: float) -> void:
	if cricticalState == false:
		UserText.visible = true
		LocationText.visible = true
		MentalState.visible = true
		if injury:
			InjuryText.visible = true
			InjuryText.text = "Sustained injury: broken leg"
			InjuryText.text = "Sustained injury: wounded leg"
			InjuryText.text = "Sustained injury: broken arm"
			InjuryText.text = "Sustained injury: wounded arm"
			InjuryText.text = "Sustained injury:\nhead trauma"
		else:
			InjuryText.visible = false
		MedicalText.visible = false
	if cricticalState:
		UserText.visible = false
		LocationText.visible = false
		MentalState.visible = false
		InjuryText.visible = false
		MedicalText.visible = true
		timer +=1
		if timer >= 150:
			changecolor()
			timer = 0
	
func changecolor():
	if medicalColor:
		medicalColor = false
		MedicalText.set("theme_override_colors/font_color",Color(1.0, 0.0, 0.0, 1.0))
		MedicalText.set("theme_override_colors/font_outline_color",Color(0.271, 0.0, 0.0, 1.0))
	else:
		medicalColor = true
		MedicalText.set("theme_override_colors/font_color",Color(0.0, 1.0, 0.0, 1.0))
		MedicalText.set("theme_override_colors/font_outline_color",Color(0.0, 0.271, 0.0, 1.0))
