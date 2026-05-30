extends Node

const save_location = "user://SaveFile.json"

var contents_to_save: Dictionary = {
	"difficulty" = 1,
	"CharID" = 0,
	"MaxKills" = 0,
	"EKills" = 0,
	"HKills" = 0,
	"NKills" = 0,
	"NPKills" = 0,
	"AppropriateTaunt" = false,
	"NoSwears" = false,
	"NoWoundDescriptions" = false,
	"NoSwearsInVoice" = false,
	"NoMentionsSuicide" = false,
	"VoiceActing" = true,
	"NoOffensiveVoicelines" = false,
	"NoOffensiveText" = false,
	"Music" = true,
	"SFX" = true,
	"VoidUnlocked" = false,
	"GuyDarkheartUnlocked" = false,
	"MilkyUnlocked" = false,
	"HellBasherUnlocked" = false,
	"nooxinwatch" = true
}

func _ready() -> void:
	#DirAccess.remove_absolute("user://SaveFile.json")
	_load()

func _save():
	var file = FileAccess.open(save_location, FileAccess.WRITE)
	file.store_var(contents_to_save.duplicate())
	file.close()
	
func _load():
	if FileAccess.file_exists(save_location):
		var file = FileAccess.open(save_location, FileAccess.READ)
		var data = file.get_var()
		file.close()
		
		var save_data = data.duplicate()
		contents_to_save.difficulty = save_data.difficulty
		contents_to_save.CharID = save_data.CharID
		contents_to_save.MaxKills = save_data.MaxKills
		contents_to_save.EKills = save_data.EKills
		contents_to_save.HKills = save_data.HKills
		contents_to_save.NKills = save_data.NKills
		contents_to_save.NPKills = save_data.NPKills
		contents_to_save.AppropriateTaunt = save_data.AppropriateTaunt
		contents_to_save.NoSwears = save_data.NoSwears
		contents_to_save.NoWoundDescriptions = save_data.NoWoundDescriptions
		contents_to_save.NoSwearsInVoice = save_data.NoSwearsInVoice
		contents_to_save.NoMentionsSuicide = save_data.NoMentionsSuicide
		contents_to_save.VoiceActing = save_data.VoiceActing
		contents_to_save.NoOffensiveVoicelines = save_data.NoOffensiveVoicelines
		contents_to_save.NoOffensiveText = save_data.NoOffensiveText
		contents_to_save.Music = save_data.Music
		contents_to_save.SFX = save_data.SFX
		contents_to_save.VoidUnlocked = save_data.VoidUnlocked
		contents_to_save.GuyDarkheartUnlocked = save_data.GuyDarkheartUnlocked
		contents_to_save.MilkyUnlocked = save_data.MilkyUnlocked
		contents_to_save.HellBasherUnlocked = save_data.HellBasherUnlocked
		contents_to_save.nooxinwatch = save_data.nooxinwatch
