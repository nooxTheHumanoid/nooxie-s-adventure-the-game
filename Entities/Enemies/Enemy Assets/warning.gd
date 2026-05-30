extends Node2D

var player 
func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")
	global_position = player.position
	global_rotation = 0.0

func _process(_delta: float) -> void:
	global_position = player.position
	global_rotation = 0.0
