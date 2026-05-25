extends CanvasLayer

@onready var Text = $DeathText
@onready var Music = $Music
@export_file var Level
@export_file var path
var randomText = randi_range(1,4)
func _ready() -> void:
	#visible = false
	Music.playing = global.Music_Enabled
	get_tree().get_first_node_in_group("Player").queue_free()
	if randomText == 1:
		Text.text = "They were left in dispair."
	elif randomText == 2:
		Text.text = "They have forgotten you." #It's not that they don't want to be remembered it's just that they'll be forgotten either way.
		#Text.text = "Finally... I've gotten the sweet taste of death... It's so cold... so miserable... I feel the sweet embrace from death itself."
	elif randomText == 3 && global.character == 0:
		Text.text = "You promised them that they won't be forgotten."
	#elif randomText == 3:
		#Text.text = "My time has come... this feeling... it's like somebody taking weights off my chest... it's... relieving."
	else:
		Text.text = "The only hope dies."
	
func _on_restart_pressed() -> void:
	if Level == null:
		return
	get_tree().change_scene_to_file(Level)
	queue_free()

func _on_menu_pressed() -> void:
	if path == null:
		return
	get_tree().change_scene_to_file(path)
	queue_free()
