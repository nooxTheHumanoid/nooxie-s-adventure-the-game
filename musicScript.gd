extends AudioStreamPlayer

func _ready() -> void:
	if global.Music_Enabled:
		playing = true
	else:
		playing = false
