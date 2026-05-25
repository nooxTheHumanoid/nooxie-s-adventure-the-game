extends Button

@export var Maincamera : Camera2D
@export var camera : Camera2D
func _on_pressed() -> void:
	if camera == null || Maincamera == null:
		return
	Maincamera.enabled = false
	camera.enabled = true
