extends Area2D

class_name Enemy

enum deathmode{
	stomped,
	falling
}
enum AImode{
	Walking,
	Shotgun,
	Sniper
}
enum AIstate{
	Offensive,
	Aggressive,
	Defensive
}

@export var horizontal_speed = 30
@export var vertical_speed = 100
var damage = 7
var health = 1
@export_group("easy mode")
@export var Edmg = 2
@export var Ehp = 1
@export_group("")
@export_group("normal mode")
@export var dmg = 7
@export var hp = 1
@export_group("")
@export_group("hard mode")
@export var Hdmg = 10
@export var Hhp = 2
@export_group("")
@export_group("nooxin mode")
@export var Ndmg = 15
@export var Nhp = 5
@export_group("")
@export_group("nooxin+ mode")
@export var NPdmg = 21
@export var NPhp = 7
@export_group("")
@export var Death_Anim = deathmode.stomped
@export var AI_mode = AImode.Walking
@export var AI_State = AIstate.Offensive
@export var recoverytime = 1.5
@export var auto_act = false
@export var show_healthbar = false
@onready var ray_cast = $RayCast2D as RayCast2D
@onready var wall_detector = $WallDetect as RayCast2D
@onready var wall_detector2 = $WallDetect2 as RayCast2D
@onready var animations = $AnimatedSprite2D as AnimatedSprite2D
@onready var detector = $Detection as Area2D
@onready var health_bar = $HealthBar

var recovered = true
var dead = false
var playerdetected = null
var rerolltime = randi_range(1, 10)
var reroll = true
var random = 0
var tempspeed = 0

func _ready() -> void:
	health_bar.visible = true
	global.enemies += 1
	if show_healthbar == false:
		health_bar.visible = false
	if playerdetected == null and auto_act == true:
		detector.scale.x = 1000
		detector.scale.y = 1000
	if global.GameDifficulty == 0:
		damage = Edmg
		health = Ehp
	if global.GameDifficulty == 1:
		damage = dmg
		health = hp
	if global.GameDifficulty == 2:
		damage = Hdmg
		health = Hhp
	if global.GameDifficulty == 3:
		damage = Ndmg
		health = Nhp
	if global.GameDifficulty == 4:
		damage = NPdmg
		health = NPhp
	health_bar.init_health(health)

func _process(delta):
	if health >= 0 && playerdetected != null && AI_mode != AImode.Sniper && not dead:
		animations.play("Walk")
		position.x -= delta * horizontal_speed
		
		if (wall_detector.is_colliding() && horizontal_speed > 0) or (wall_detector2.is_colliding() && horizontal_speed < 0):
			horizontal_speed = horizontal_speed * -1
			recovered = false
			get_tree().create_timer(recoverytime).timeout.connect(recover)
			
	if !ray_cast.is_colliding():
		position.y += delta * vertical_speed
	
	if health >=0 && playerdetected != null && AI_mode != AImode.Walking && not dead:
		if playerdetected.position.x < global_position.x:
			animations.flip_h = true
		else:
			animations.flip_h = false
		
	if health >=0 && playerdetected != null && AI_mode == AImode.Shotgun && recovered && not dead:
		if reroll:
			random = randi_range(1, 2)
			reroll = false
			get_tree().create_timer(rerolltime).timeout.connect(rerolling)
		
		#make AI stop moving when player dies
		if AI_State == AIstate.Aggressive:
			if (playerdetected.position.x < global_position.x && horizontal_speed < 0) or (playerdetected.position.x > global_position.x && horizontal_speed > 0):
				horizontal_speed = horizontal_speed * -1
		elif AI_State == AIstate.Defensive:
			if (playerdetected.position.x < global_position.x && horizontal_speed > 0) or (playerdetected.position.x > global_position.x && horizontal_speed < 0):
				horizontal_speed = horizontal_speed * -1
		elif AI_State == AIstate.Offensive and random == 1:
			rerolltime = randi_range(1, 10)
			if (playerdetected.position.x < global_position.x && horizontal_speed > 0) or (playerdetected.position.x > global_position.x && horizontal_speed < 0):
				horizontal_speed = horizontal_speed * -1
		elif AI_State == AIstate.Offensive and random == 2:
			rerolltime = randi_range(1, 10)
			if (playerdetected.position.x < global_position.x && horizontal_speed < 0) or (playerdetected.position.x > global_position.x && horizontal_speed > 0):
				horizontal_speed = horizontal_speed * -1
			
	# DO NOT USE SNIPER MODE... yet
	if health >=0 && playerdetected != null && AI_mode == AImode.Sniper && recovered && not dead:
		#print(playerdetected.position.x," ",global_position.x)
		animations.play("default")
		if (playerdetected.position.x < global_position.x+30 && horizontal_speed > 0) or (playerdetected.position.x > global_position.x-30 && horizontal_speed < 0):
			animations.play("Walk")
			position.x -= delta * tempspeed
		elif (playerdetected.position.x < global_position.x && horizontal_speed > 0) or (playerdetected.position.x > global_position.x && horizontal_speed < 0):
			tempspeed = horizontal_speed * -1
			animations.play("default")
		
	
	if health <= 0:
		if not dead:
			animations.flip_h = false
			global.kills += 1 
			global.tempkills += 1
			global.enemies -=1
			dead = true
			die()

func hurtEnemy(PlayerDamage):
	if not dead:
		health -= PlayerDamage
		health_bar.set_health(health)

func die():
	if Death_Anim == deathmode.stomped:
		horizontal_speed = 0
		vertical_speed = 0
		animations.play("Death")
		var death_tween = get_tree().create_tween()
		death_tween.tween_property(self, "position", position, .75)
		death_tween.tween_callback(func (): queue_free())
	if Death_Anim == deathmode.falling:
		horizontal_speed = 0
		vertical_speed = 0
		animations.play("Death")
		var death_tween = get_tree().create_tween()
		death_tween.tween_property(self, "position", position + Vector2(0, -48), .5)
		death_tween.chain().tween_property(self,"position", position + Vector2(0,256),1)
		death_tween.tween_callback(func (): queue_free())
	
func detectedPlayer(player):
	playerdetected = player

func recover():
	recovered = true

func rerolling():
	reroll = true
