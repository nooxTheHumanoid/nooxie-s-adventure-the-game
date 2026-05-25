extends Control

@onready var MenuMusic = $"../music"
@onready var musicBox = $Music
@onready var SFXBox = $SFX
@onready var Taunt = $CensorTaunt
@onready var SwearT = $CensorTextSwear
@onready var SwearV = $CensorVoiceSwear
@onready var Wounds = $CensorWoundDesc
@onready var Suicide = $CensorSuicide
@onready var OffT = $CensorOffText
@onready var OffV = $CensorOffVoice
@onready var VoiceActing = $VoiceActing

func _ready() -> void:
	SaveData._load()
	global.character = SaveData.contents_to_save.CharID
	global.Music_Enabled = SaveData.contents_to_save.Music
	global.SFX_Enabled = SaveData.contents_to_save.SFX
	global.censor_taunts = SaveData.contents_to_save.AppropriateTaunt
	global.censor_swearT = SaveData.contents_to_save.NoSwears
	global.censor_wounds = SaveData.contents_to_save.NoWoundDescriptions
	global.censor_swearV = SaveData.contents_to_save.NoSwearsInVoice
	global.disable_suicide = SaveData.contents_to_save.NoMentionsSuicide
	global.VoiceActing = SaveData.contents_to_save.VoiceActing
	global.censor_OffV = SaveData.contents_to_save.NoOffensiveVoicelines
	global.censor_OffT = SaveData.contents_to_save.NoOffensiveText
	if global.Music_Enabled:
		musicBox.button_pressed = true
		MenuMusic.playing = true
	else:
		musicBox.button_pressed = false
		MenuMusic.playing = false
	if global.SFX_Enabled:
		SFXBox.button_pressed = true
	else:
		SFXBox.button_pressed = false
	
	Taunt.button_pressed = global.censor_taunts
	SwearT.button_pressed = global.censor_swearT
	SwearV.button_pressed = global.censor_swearV
	Wounds.button_pressed = global.censor_wounds
	Suicide.button_pressed = global.disable_suicide
	OffT.button_pressed = global.censor_OffT
	OffV.button_pressed = global.censor_OffV
	VoiceActing.button_pressed = global.VoiceActing
	

func _on_music_toggled(toggled_on: bool) -> void:
	global.Music_Enabled = toggled_on
	SaveData.contents_to_save.Music = toggled_on
	MenuMusic.playing = toggled_on
	SaveData._save()


func _on_sfx_toggled(toggled_on: bool) -> void:
	global.SFX_Enabled = toggled_on
	SaveData.contents_to_save.SFX = toggled_on
	SaveData._save()


func _on_censor_taunt_toggled(toggled_on: bool) -> void:
	global.censor_taunts = toggled_on
	SaveData.contents_to_save.AppropriateTaunt = toggled_on
	SaveData._save()


func _on_censor_text_swear_toggled(toggled_on: bool) -> void:
	global.censor_swearT = toggled_on
	SaveData.contents_to_save.NoSwears = toggled_on
	SaveData._save()


func _on_censor_voice_swear_toggled(toggled_on: bool) -> void:
	global.censor_swearV = toggled_on
	SaveData.contents_to_save.NoSwearsInVoice = toggled_on
	SaveData._save()

func _on_censor_wound_desc_toggled(toggled_on: bool) -> void:
	global.censor_wounds = toggled_on
	SaveData.contents_to_save.NoWoundDescriptions = toggled_on
	SaveData._save()


func _on_censor_suicide_toggled(toggled_on: bool) -> void:
	global.disable_suicide = toggled_on
	SaveData.contents_to_save.NoMentionsSuicide = toggled_on
	SaveData._save()


func _on_censor_off_text_toggled(toggled_on: bool) -> void:
	global.censor_OffT = toggled_on
	SaveData.contents_to_save.NoOffensiveText = toggled_on
	SaveData._save()


func _on_censor_off_voice_toggled(toggled_on: bool) -> void:
	global.censor_OffV = toggled_on
	SaveData.contents_to_save.NoOffensiveVoice = toggled_on
	SaveData._save()


func _on_voice_acting_toggled(toggled_on: bool) -> void:
	global.VoiceActing = toggled_on
	SaveData.contents_to_save.VoiceActing = toggled_on
	SaveData._save()
