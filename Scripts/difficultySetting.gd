extends OptionButton

func _ready() -> void:
	SaveData._load()
	global.GameDifficulty = SaveData.contents_to_save.difficulty
	selected = global.GameDifficulty

func _on_item_selected(index: int) -> void:
	global.GameDifficulty = index
	SaveData.contents_to_save.difficulty = global.GameDifficulty
	SaveData._save()
