extends Node2D

@onready var animator: AnimatedSprite2D = $AnimatedSprite2D

@export var y_offset = 0.0

var AimSpeed = 420.0
var instaAim = true
@export var can_drop = true
var canfire = false
var State = "none"
@export var firecd: float = 0.5
var actualfire = false
@export var Heal: float = 0.0
@export var Defence: float = 0.0
@export var DMGboost: float = 0.0
@export var Mood: float = 0.0
@export var Pain: float = 0.0
@export var HeadInjury: float = 0.0
@export var LegInjury: float = 0.0
@export var BrokenLeg: float = 0.0
@export var ArmInjury: float = 0.0
@export var BrokenArm: float = 0.0
@export var InjectionSickness: int = 1
@export var Stamina: float = 0.0
@export var Visibility: float = 0.0

var DmgMulti = 0
var currentDMG = 0

func can_be_dropped():
	return can_drop
	
func gunAim(Aspeed,InstaAim):
	AimSpeed = Aspeed
	instaAim = InstaAim

func cdnumber(cdnum):
	firecd = cdnum

func dmgMulti(dmg):
	DmgMulti = dmg
	
func dmgnumber(dmg):
	currentDMG = dmg
	
	
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
		if canfire and visible == true:
			canfire = false
			actualfire = true
			if global.SFX_Enabled:
				pass
				#firesound.play()
			if get_tree().get_first_node_in_group("Player"):
				var plr = get_tree().get_first_node_in_group("Player")
				plr.HealUp(Heal)
				plr.DefenceUp(Defence)
				plr.DMGBoostUp(DMGboost)
				plr.moodUp(Mood)
				plr.PainUp(Pain)
				plr.HeadInjUp(HeadInjury)
				plr.LegInjUp(LegInjury)
				plr.BrokenLegUp(BrokenLeg)
				plr.ArmInjUp(ArmInjury)
				plr.BrokenArmUp(BrokenArm)
				plr.SicknessUp(InjectionSickness)
				plr.StaminaUp(Stamina)
				plr.VisibilityUp(Visibility)
			animator.fireshotty()
			get_tree().create_timer(firecd).timeout.connect(FiredcooldownOff)

func mayIswap():
	return true
	
func fireNOW():
	pass #It's a syringe/injector how can I fire bullets?
