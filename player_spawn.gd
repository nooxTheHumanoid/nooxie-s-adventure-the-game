extends Node2D

enum PlayerMode {
	regular,
	nohands
}
@export var nx : PackedScene
@export var voidman : PackedScene
@export var guyD : PackedScene
@export var Milky : PackedScene
@export var camera : Camera2D
@export var song : AudioStreamMP3
@export_file var level
@export_group("CharSettings")
@export var PlayerHasgun = PlayerMode.nohands
@export var show_stats = true
@export var defence = 0.0
@export var Force_hp = false
@export var New_HP = 0.0
@export var CanHeal_viaTaunt = false
@export var HealthFromTaunting = 0.01
@export var HealWaitFromTaunt = 0.5

func _ready() -> void:
	if global.character == 0:
		var player = nx.instantiate()
		player.position = position
		player.Player_Mode = PlayerHasgun
		player.LevelSong = song
		player.camera_sync = camera
		player.should_camera_sync = true
		player.Current_scene = level
		player.defence = defence
		if show_stats == false:
			player.Show_Health = false
			player.Show_defence = false
		if Force_hp:
			player.health = New_HP
		if CanHeal_viaTaunt:
			player.CanHeal_viaTaunt = true
			player.HealthFromTaunting = HealthFromTaunting
			player.HealWaitFromTaunt = HealWaitFromTaunt
		get_parent().get_parent().add_child(player)
	elif global.character == 1:
		var player = voidman.instantiate()
		player.position = position
		player.Player_Mode = PlayerHasgun
		player.LevelSong = song
		player.camera_sync = camera
		player.should_camera_sync = true
		player.Current_scene = level
		#player.defence = defence
		if show_stats == false:
			player.Show_Health = false
			player.Show_defence = false
		if Force_hp:
			player.health = New_HP
		if CanHeal_viaTaunt:
			player.CanHeal_viaTaunt = true
			player.HealthFromTaunting = HealthFromTaunting
			player.HealWaitFromTaunt = HealWaitFromTaunt
		get_parent().get_parent().add_child(player)
	elif global.character == 2:
		var player = guyD.instantiate()
		player.position = position
		player.Player_Mode = PlayerHasgun
		player.LevelSong = song
		player.camera_sync = camera
		player.should_camera_sync = true
		player.Current_scene = level
		#player.defence = defence
		if show_stats == false:
			player.Show_Health = false
			player.Show_defence = false
		if Force_hp:
			player.health = New_HP
		if CanHeal_viaTaunt:
			player.CanHeal_viaTaunt = true
			player.HealthFromTaunting = HealthFromTaunting
			player.HealWaitFromTaunt = HealWaitFromTaunt
		get_parent().get_parent().add_child(player)
	elif global.character == 3:
		var player = Milky.instantiate()
		player.position = position
		player.Player_Mode = PlayerHasgun
		player.LevelSong = song
		player.camera_sync = camera
		player.should_camera_sync = true
		player.Current_scene = level
		#player.defence = defence
		if show_stats == false:
			player.Show_Health = false
			player.Show_defence = false
		if Force_hp:
			player.health = New_HP
		if CanHeal_viaTaunt:
			player.CanHeal_viaTaunt = true
			player.HealthFromTaunting = HealthFromTaunting
			player.HealWaitFromTaunt = HealWaitFromTaunt
		get_parent().get_parent().add_child(player)
		
	queue_free()
