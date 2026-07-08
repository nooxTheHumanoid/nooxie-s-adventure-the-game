extends Node2D

const BULLET = preload('res://things/Slug.tscn')

@onready var muzzle: Marker2D = $Marker2D
@onready var animator: AnimatedSprite2D = $AnimatedSprite2D
@onready var firesound = $Fire

@export var y_offset = 8.0
@export var can_dorp: bool = true
@export var ammo: int = 21
@export var burst: int = 1
@export var InfAmmo: bool = false

var AimSpeed = 420.0
var instaAim: bool = true
var DmgMulti = 1.0
var canfire: bool = false
var State = "none"
@export var firecd: float = 0.5
var actualfire: bool = false
@export var currentDMG: float = 0.0
@export var bulletHP: float = 2.0
@export var burstcd: float = 0.1
var shotsfromBurst: int = 0

func dmgMulti(dmg):
	DmgMulti = dmg
	
func gunAim(Aspeed,InstaAim):
	AimSpeed = Aspeed
	instaAim = InstaAim
	
func dmgnumber(dmg):
	currentDMG = dmg
	
func bulletnum(hp):
	bulletHP = hp

func cdnumber(cdnum):
	firecd = cdnum
	
func burstcdnumber(cdnum):
	burstcd = cdnum

func state_char_anim(StateAnim: String):
	State = StateAnim

func char_skin(Hskin):
	animator.skin(Hskin)
	animator.loadSkin()

func modenotifforguns(player_guns: Player.PlayerMode):
	if player_guns == Player.PlayerMode.nohands && State == "none":
		visible = true
		position.y = y_offset
	elif player_guns == Player.PlayerMode.nohands && State == "duck":
		visible = true
		position.y = y_offset + 3
	elif player_guns == Player.PlayerMode.nohands && State == "taunt":
		visible = false
		canfire = false
		position.y = y_offset
	else:
		visible = false
		canfire = false
		position.y = y_offset

func FiredcooldownOff():
	canfire = true
	actualfire=false
	shotsfromBurst = 0
	
func burstFire():
	if shotsfromBurst < burst:
		shotsfromBurst += 1
		canfire = false
		actualfire = true
		if global.SFX_Enabled:
			firesound.play()
		if !InfAmmo:
			ammo -= 1
		var bullet_instance = BULLET.instantiate()
		get_tree().root.add_child(bullet_instance)
		bullet_instance.global_position = muzzle.global_position
		bullet_instance.rotation = rotation
		bullet_instance.damagVal(currentDMG*DmgMulti)
		bullet_instance.healthVal(bulletHP)
		animator.fireshotty()
		get_tree().create_timer(burstcd).timeout.connect(burstFire)
	if shotsfromBurst >= burst:
		get_tree().create_timer(firecd).timeout.connect(FiredcooldownOff)
	
func fireNOW():
	if canfire and visible == true && ammo >= 1 && shotsfromBurst == 0:
		canfire = false
		actualfire = true
		burstFire()
		


func _physics_process(delta: float) -> void:
	if actualfire == false && visible == true:
		canfire = true
	if instaAim == false:
		var mouse = rad_to_deg(global_position.angle_to_point(get_global_mouse_position()))
		if (abs (rotation_degrees - mouse) > 180):
			mouse = mouse + 360 if mouse < 0 else mouse - 360
		rotation_degrees = move_toward(rotation_degrees,mouse,AimSpeed* delta)
		rotation_degrees = rotation_degrees + 360 if rotation_degrees < -180 else (rotation_degrees - 360 if rotation_degrees > 180 else rotation_degrees)
		if rotation_degrees > 90 or rotation_degrees < -90:
			scale.y = -1
			position.x = 0.25
		else:
			scale.y = 1
			position.x = 0.0
	else:
		look_at(get_global_mouse_position())
		rotation_degrees = wrap(rotation_degrees, 0 , 360)
		if rotation_degrees > 90 and rotation_degrees < 270:
			scale.y = -1
			position.x = 0.25
		else:
			scale.y = 1
			position.x = 0.0
		
	if (Input.is_action_just_pressed("shoot") && global.holdfire == false) or (Input.is_action_pressed("shoot") && global.holdfire):
		fireNOW()
			

func mayIswap():
	return true
