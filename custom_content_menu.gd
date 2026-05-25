extends Node2D

const CONTENT_BUTTON = preload("res://things/CustomButton.tscn")

@export_dir var dir_path

@onready var grid = $Control/GridContainer

func _ready() -> void:
	get_content(dir_path)

func get_content(path) -> void:
	if path == null:
		return
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if file_name.ends_with(".remap"):
				file_name = file_name.replace(".remap", "")
			print("Found file: " + file_name)
			create_button('%s/%s' % [dir.get_current_dir(), file_name],file_name)
			file_name = dir.get_next()
		dir.list_dir_end()
	else:
		print("An error occurred when trying to access the path.")
		
func create_button(content_path: String, content_name: String) -> void:
	var btn = CONTENT_BUTTON.instantiate()
	btn.text = content_name
	btn.custom_content_path = content_path
	grid.add_child(btn)
