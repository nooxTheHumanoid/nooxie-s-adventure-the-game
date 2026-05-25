extends Control

@onready var label = $Label
@onready var wavelabel = $Waves
@onready var enemycount = $count
@onready var Hi_kill = $MaxKills
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = true
	global.kills = 0
	global.Wave = 1
	global.maxenemies = 5
	wavelabel.text = "Danger Level: " + str(global.Wave)
	SaveData._load()
	if SaveData.contents_to_save.difficulty == 0:
		global.MaxKills = SaveData.contents_to_save.EKills
	elif SaveData.contents_to_save.difficulty == 1:
		global.MaxKills = SaveData.contents_to_save.MaxKills
	elif SaveData.contents_to_save.difficulty == 2:
		global.MaxKills = SaveData.contents_to_save.HKills
	elif SaveData.contents_to_save.difficulty == 3:
		global.MaxKills = SaveData.contents_to_save.NKills
	elif SaveData.contents_to_save.difficulty == 4:
		global.MaxKills = SaveData.contents_to_save.NPKills
	



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	label.text = "Kills: " + str(global.kills)
	Hi_kill.text = "Max Kills: " + str(global.MaxKills)
	#wavelabel.text = "Wave: " + str(global.Wave)
	wavelabel.text = "Danger Level: " + str(global.Wave)
	enemycount.text = str(global.enemies) + "/" + str(global.maxenemies)
	if global.kills >= global.MaxKills:
		global.MaxKills = global.kills
		if SaveData.contents_to_save.difficulty == 0:
			SaveData.contents_to_save.EKills = global.MaxKills
		elif SaveData.contents_to_save.difficulty == 1:
			SaveData.contents_to_save.MaxKills = global.MaxKills
		elif SaveData.contents_to_save.difficulty == 2:
			SaveData.contents_to_save.HKills = global.MaxKills
		elif SaveData.contents_to_save.difficulty == 3:
			SaveData.contents_to_save.NKills = global.MaxKills
		elif SaveData.contents_to_save.difficulty == 4:
			SaveData.contents_to_save.NPKills = global.MaxKills
		SaveData._save()
	if get_tree().get_first_node_in_group("Player") == null:
		visible = false
