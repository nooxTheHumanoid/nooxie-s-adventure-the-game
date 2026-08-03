extends Node2D

@onready var hitbox: CollisionShape2D = $Area2D/CollisionShape2D
@onready var animator: AnimatedSprite2D = $AnimatedSprite2D
@onready var sprite: Sprite2D = $Sprite2D

@export var y_offset = 0.0

var AimSpeed = 420.0
var instaAim = true
@export var deflectBullets = true
@export var can_drop = true
var DmgMulti = 1.0
var canfire = false
var State = "none"
@export var firecd: float = 0.5
var actualfire = false
@export var currentDMG: float = 4.0
@export var hitboxLinger: float = 0.4
@export var DMGbullet: float = 0.5
@export var increased_damage_multi = false

func can_be_dropped():
	return can_drop

func dmgMulti(dmg):
	DmgMulti = dmg
	
func dmgnumber(dmg):
	currentDMG = dmg
	
func bulletnum(hp):
	DMGbullet = hp
	
func gunAim(Aspeed,InstaAim):
	AimSpeed = Aspeed
	instaAim = InstaAim

func cdnumber(cdnum):
	firecd = cdnum

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
	
func hitboxOff():
	hitbox.disabled = true
	sprite.visible = false
	get_tree().create_timer(firecd).timeout.connect(FiredcooldownOff)

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
			hitbox.disabled = false
			sprite.visible = true
			animator.fireshotty()
			get_tree().create_timer(hitboxLinger).timeout.connect(hitboxOff)

func mayIswap():
	return true
	
func fireNOW():
	pass #It's a melee weapon how can I fire bullets?
	
func handle_enemy_collision(enemy: Enemy):
	if enemy == null:
		return
	
	if enemy.health >= 0:
		if increased_damage_multi && DmgMulti > 1.0:
			enemy.hurtEnemy(currentDMG*(DmgMulti*3))
		else:
			enemy.hurtEnemy(currentDMG*DmgMulti)
		
func handle_enemy_collision2(enemy: EnemyMafia):
	if enemy == null:
		return
	
	if enemy.health >= 0:
		if increased_damage_multi && DmgMulti > 1.0:
			enemy.hurtEnemy(currentDMG*(DmgMulti*3))
		else:
			enemy.hurtEnemy(currentDMG*DmgMulti)
	
func handle_bullet_collision(bullet: Node2D):
	if bullet == null:
		return
	
	if bullet != null:
		bullet.dmgBullet(DMGbullet)
		if deflectBullets:
			bullet.harmother(true)
			if bullet.bulisReverse():
				bullet.bulReverse(false)
			else:
				bullet.bulReverse(true)
			

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area is Enemy:
		handle_enemy_collision(area)
	if area is EnemyMafia:
		handle_enemy_collision2(area)
	if area.get_parent() is EnemyBullet:
		handle_bullet_collision(area.get_parent())
