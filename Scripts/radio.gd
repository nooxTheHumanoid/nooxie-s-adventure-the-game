extends Area2D

@onready var area = $"."
@onready var text = $Label
@onready var anim = $Sprite2D

# Gotta find a better way to load these songs
@onready var NXl = $NXlab
@onready var DrNl = $DrNlab
@onready var DrOnxyl = $DrOnyxlab

var player_nearby: bool = false
var currentSong: int = randi_range(1,3)

func _ready() -> void:
	text.visible = false
	if !global.Music_Enabled:
		currentSong = 0
	if currentSong == 1:
		NXl.playing = true
		DrNl.playing = false
		DrOnxyl.playing = false
		anim.play("one")
	elif currentSong == 2:
		NXl.playing = false
		DrNl.playing = true
		DrOnxyl.playing = false
		anim.play("two")
	elif currentSong == 3:
		NXl.playing = false
		DrNl.playing = false
		DrOnxyl.playing = true
		anim.play("three")
	else:
		NXl.playing = false
		DrNl.playing = false
		DrOnxyl.playing = false
		anim.play("one")

func _process(_delta: float) -> void:
	if player_nearby:
		if Input.is_action_just_pressed("interact"):
			change_music()
		

func change_music():
	if global.Music_Enabled:
		if currentSong < 3:
			currentSong += 1
		else:
			currentSong = 1
	else: 
		currentSong = 0
	if currentSong == 1:
		NXl.playing = true
		DrNl.playing = false
		DrOnxyl.playing = false
		anim.play("one")
	elif currentSong == 2:
		NXl.playing = false
		DrNl.playing = true
		DrOnxyl.playing = false
		anim.play("two")
	elif currentSong == 3:
		NXl.playing = false
		DrNl.playing = false
		DrOnxyl.playing = true
		anim.play("three")
	else:
		NXl.playing = false
		DrNl.playing = false
		DrOnxyl.playing = false
		anim.play("one")


func _on_body_shape_entered(_body_rid: RID, _body: Node2D, _body_shape_index: int, _local_shape_index: int) -> void:
	text.visible = true
	player_nearby = true
	
func _on_body_shape_exited(_body_rid: RID, _body: Node2D, _body_shape_index: int, _local_shape_index: int) -> void:
	text.visible = false
	player_nearby = false
