extends CanvasLayer
@onready var resume = $ColorRect2/resume
@onready var menu = $ColorRect2/Menu

@export_file var path

func _ready() -> void:
	visible = false
	get_tree().paused = false
	
func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("pause"):
		if get_tree().paused:
			visible = false
			get_tree().paused = false
		else:
			visible = true
			get_tree().paused = true

func _on_resume_pressed() -> void:
	visible = false
	get_tree().paused = false

func _on_menu_pressed() -> void:
	if path == null:
		return
	get_tree().change_scene_to_file(path)
	queue_free()
