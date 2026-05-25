extends Node2D

@export_dir var dir_path

@onready var CharnameText = $UI/Charname
@onready var DescText = $UI/VScrollBar/VSplitContainer/Description
@onready var StatText = $UI/Stats
@onready var MechanicText = $UI/Mechanic
@onready var QuirkText = $UI/Quirks
@onready var StartingItemText = $UI/StartingItems
@onready var CharacterPortrait = $Charport
@onready var optionButton = $Characters

var id = 0 #I'll figure things out. Gonna hard code the characters in for now.

func _ready() -> void:
	optionButton.selected = global.character
	if global.character == 0:
		CharnameText.text = "noox nooxie nooxTheHumanoid NX Noxious noxon nooxin'"
		DescText.text = "A 2'1 feet short humanoid who can change their height to be up to 21 feet tall. He's very strong but fragile guy. 
	He's sadistic and masochistic even though he cannot feel pain at all.
	He doesn't not respect humans to the point he kills them. Some humans are lucky to get on his good side.
	His sadistic ass once impaled a guy by summoning spikes out of the ground and made the guy watch how noox tortures the poor fella's family, leaving no one alive. After that noox tore the man's jaw off and shoved the jaw down the man's throat. 
For noox, respect is everything.
The main man himself."
		StatText.text = "Stats\nHP: 21\nSpeed: 100\nSprint Bonus: 2X\nStomp Damage: 5\nJumpPower: 400\nCoyote Time: 0.3 seconds\nStamina: INF\nStamina Gain: INF\nStamina Drain: 0"
		MechanicText.text = "Unique mechanic:\nEach kill adds defence."
		QuirkText.text = "Characrer Quirks:\nOnly slugs (all shotguns only fire slugs)\nLoyal tools (Cannot swap and drop melee weapons)\nCollected mind (Improbable to be distressed while in action)\nPTSD (When distressed: faster sprint speed, take more damage)"
		StartingItemText.text = "Starting toys:\nShotty,Mag-12,SledgeHammer,Emerald Scythe, Knife"
		CharacterPortrait.texture = ResourceLoader.load("res://textures/CharacterPortraits/NXV2.png")
	elif global.character == 1:
		CharnameText.text = "null"
		DescText.text = "But nobody came."
		StatText.text = "Stats\nHP: ?\nSpeed: ?\nSprint Bonus: ?X\nStomp Damage: ?\nJumpPower: ?\nCoyote Time: ? seconds\nStamina: ?\nStamina Gain: ?\nStamina Drain: ?"
		MechanicText.text = "Unique mechanic:\nVoid."
		QuirkText.text = "Characrer Quirks:\nYou're left in despair."
		StartingItemText.text = "Starting ?:\n?"
		CharacterPortrait.texture = ResourceLoader.load("res://textures/CharacterPortraits/MysteryMan.png")
	elif global.character == 2:
		CharnameText.text = "Guy Darkheart"
		DescText.text = "He's left handed."
		StatText.text = "Stats\nHP: 120\nSpeed: 100\nSprint Bonus: 1.8X\nStomp Damage: 2.5\nJumpPower: 400\nCoyote Time: 0.2 seconds\nStamina: 100\nStamina Gain: 20\nStamina Drain: 10"
		MechanicText.text = "Unique mechanic:\nMercs die twice."
		QuirkText.text = "Characrer Quirks:\nMute.\nNo Trigger Discipline."
		StartingItemText.text = "Starting weapons:\nRifle"
		CharacterPortrait.texture = ResourceLoader.load("res://textures/CharacterPortraits/GuyDarkheart.png")
	elif global.character == 3:
		CharnameText.text = "Milky"
		DescText.text = "I think noox got bored and decided on taking someone from a different universe."
		StatText.text = "Stats\nHP: 80\nSpeed: 110\nSprint Bonus: 2.1X\nStomp Damage: 1.5\nJumpPower: 420\nCoyote Time: 0.2 seconds\nStamina: 90\nStamina Gain: 20\nStamina Drain: 10"
		MechanicText.text = "Unique mechanic:\nDouble primaries."
		QuirkText.text = "Characrer Quirks:\nRegenerator (has passive regeneration).\nNo Trigger Discipline."
		StartingItemText.text = "Starting weapons:\nMag-12"
		CharacterPortrait.texture = ResourceLoader.load("res://textures/CharacterPortraits/Milky.png")
	#get_content(dir_path)

#func get_content(path) -> void:
	#var dir = DirAccess.open(path)
	#if dir:
		#dir.list_dir_begin()
		#var file_name = dir.get_next()
		#while file_name != "":
			#id += 1
			#if file_name.ends_with(".remap"):
				#file_name = file_name.replace(".remap", "")
			#print("Found file: " + file_name)
			#optionButton.add_item(file_name)
			#file_name = dir.get_next()
		#dir.list_dir_end()
	#else:
		#print("An error occurred when trying to access the path.")


func _on_characters_item_selected(index: int) -> void:
	global.character = index
	SaveData.contents_to_save.CharID = global.character
	SaveData._save()
	if index == 0:
		CharnameText.text = "noox nooxie nooxTheHumanoid NX Noxious noxon nooxin'"
		DescText.text = "A 2'1 feet short humanoid who can change their height to be up to 21 feet tall. He's very strong but fragile guy. 
	He's sadistic and masochistic even though he cannot feel pain at all.
	He doesn't not respect humans to the point he kills them. Some humans are lucky to get on his good side.
	His sadistic ass once impaled a guy by summoning spikes out of the ground and made the guy watch how noox tortures the poor fella's family, leaving no one alive. After that noox tore the man's jaw off and shoved the jaw down the man's throat. 
For noox, respect is everything.
The main man himself."
		StatText.text = "Stats\nHP: 21\nSpeed: 100\nSprint Bonus: 2X\nStomp Damage: 5\nJumpPower: 400\nCoyote Time: 0.3 seconds\nStamina: INF\nStamina Gain: INF\nStamina Drain: 0"
		MechanicText.text = "Unique mechanic:\nEach kill adds defence."
		QuirkText.text = "Characrer Quirks:\nOnly slugs (all shotguns only fire slugs)\nLoyal tools (Cannot swap and drop melee weapons)\nCollected mind (Improbable to be distressed while in action)\nPTSD (When distressed: faster sprint speed, take more damage)"
		StartingItemText.text = "Starting toys:\nShotty,Mag-12,SledgeHammer,Emerald Scythe, Knife"
		CharacterPortrait.texture = ResourceLoader.load("res://textures/CharacterPortraits/NXV2.png")
	elif index == 1:
		CharnameText.text = "null"
		DescText.text = "But nobody came."
		StatText.text = "Stats\nHP: ?\nSpeed: ?\nSprint Bonus: ?X\nStomp Damage: ?\nJumpPower: ?\nCoyote Time: ? seconds\nStamina: ?\nStamina Gain: ?\nStamina Drain: ?"
		MechanicText.text = "Unique mechanic:\nVoid."
		QuirkText.text = "Characrer Quirks:\nYou're left in despair."
		StartingItemText.text = "Starting ?:\n?"
		CharacterPortrait.texture = ResourceLoader.load("res://textures/CharacterPortraits/MysteryMan.png")
	elif index == 2:
		CharnameText.text = "Guy Darkheart"
		DescText.text = "He's left handed."
		StatText.text = "Stats\nHP: 120\nSpeed: 100\nSprint Bonus: 1.8X\nStomp Damage: 2.5\nJumpPower: 400\nCoyote Time: 0.2 seconds\nStamina: 100\nStamina Gain: 20\nStamina Drain: 10"
		MechanicText.text = "Unique mechanic:\nMercs die twice."
		QuirkText.text = "Characrer Quirks:\nMute.\nNo Trigger Discipline."
		StartingItemText.text = "Starting weapons:\nRifle"
		CharacterPortrait.texture = ResourceLoader.load("res://textures/CharacterPortraits/GuyDarkheart.png")
	elif global.character == 3:
		CharnameText.text = "Milky"
		DescText.text = "I think noox got bored and decided on taking someone from a different universe."
		StatText.text = "Stats\nHP: 80\nSpeed: 110\nSprint Bonus: 2.1X\nStomp Damage: 1.5\nJumpPower: 420\nCoyote Time: 0.2 seconds\nStamina: 90\nStamina Gain: 20\nStamina Drain: 10"
		MechanicText.text = "Unique mechanic:\nDouble primaries."
		QuirkText.text = "Characrer Quirks:\nRegenerator (has passive regeneration).\nNo Trigger Discipline."
		StartingItemText.text = "Starting weapons:\nMag-12"
		CharacterPortrait.texture = ResourceLoader.load("res://textures/CharacterPortraits/Milky.png")
