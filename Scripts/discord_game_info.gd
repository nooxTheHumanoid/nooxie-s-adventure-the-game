extends Node2D

@export var Levelname = ""
@export var menuInfo = false
@export var info = ""

func _ready():
	DiscordRPC.clear()
	DiscordRPC.app_id = 1516531360469094642
	DiscordRPC.details = Levelname
	DiscordRPC.state = "Mental State: " + str(global.Emotion)
	DiscordRPC.large_image = "placeholder"
	if !menuInfo:
		if global.GameDifficulty == 0:
			DiscordRPC.large_image_text = "Difficulty: Easy"
		elif global.GameDifficulty == 1:
			DiscordRPC.large_image_text = "Difficulty: Normal"
		elif global.GameDifficulty == 2:
			DiscordRPC.large_image_text = "Difficulty: Hard"
		elif global.GameDifficulty == 3:
			DiscordRPC.large_image_text = "Difficulty: nooxin"
		elif global.GameDifficulty == 4:
			DiscordRPC.large_image_text = "Difficulty: nooxin+"
		else:
			DiscordRPC.large_image_text = "Difficulty: Unknown"
		
		if global.character == 0:
			DiscordRPC.small_image = "nx"
			DiscordRPC.small_image_text = "Playing as noox nooxie nooxin'"
		elif global.character == 1:
			DiscordRPC.small_image = "blank"
			DiscordRPC.small_image_text = "NULL"
		elif global.character == 2:
			DiscordRPC.small_image = "guyd"
			DiscordRPC.small_image_text = "Playing as Guy Darkheart"
		elif global.character == 3:
			DiscordRPC.small_image = "milky"
			DiscordRPC.small_image_text = "Playing as Milky"
		else:
			DiscordRPC.small_image = "blank"
			DiscordRPC.small_image_text = "Playing as ???"
	else:
		DiscordRPC.details = Levelname
		DiscordRPC.large_image_text = info
		DiscordRPC.small_image = ""
		DiscordRPC.small_image_text = ""
		DiscordRPC.state = ""
	
	DiscordRPC.start_timestamp = int(Time.get_unix_time_from_system())
	DiscordRPC.refresh()

func update(death):
	if !menuInfo:
		if !death:
			DiscordRPC.state = "Mental State: " + str(global.Emotion)
		else:
			DiscordRPC.details = "Game Over"
			
	DiscordRPC.refresh()
