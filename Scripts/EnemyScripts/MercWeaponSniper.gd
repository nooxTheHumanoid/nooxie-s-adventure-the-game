extends Node2D

@onready var sprite = $Gun
@onready var muzzle: Marker2D = $Marker2D
@onready var gunrange = $"../DetectionGun"
@onready var detectionrange = $"../Detection"
@onready var lasersightRay = $lasersightcast
@onready var lasersight = $Laser
@onready var SoundFire = $Fire
@onready var SoundAlert = $"../Alert"
@onready var SoundWarn = $"../Warn"

@export var warning : PackedScene
@export var currentDMG = 7.0
@export var firingCD = 7.0
@export var mag = 1
@export var reloadtime = 0.001

@export_group("easy mode")
@export var Edmg = 3.0
@export var Ecd = 10
@export_group("")
@export_group("normal mode")
@export var dmg = 7.0
@export var cd = 7.0
@export_group("")
@export_group("hard mode")
@export var Hdmg = 10.0
@export var Hcd = 6.5
@export_group("")
@export_group("nooxin mode")
@export var Ndmg = 15.0
@export var Ncd = 6.0
@export_group("")
@export_group("nooxin+ mode")
@export var NPdmg = 21.0
@export var NPcd = 5.5
@export_group("")
var canfire = false
var reloading = false
var player = null
var maxammo = mag
var alreadysaid = false
var warnsprite
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	warnsprite = warning.instantiate()
	get_tree().create_timer(0.01).timeout.connect(sizecheck)
	sprite.play("default")
	warnsprite.visible = false
	lasersight.visible = false
	alreadysaid = false
	add_child.call_deferred(warnsprite)
	if global.GameDifficulty == 0:
		currentDMG = Edmg
		firingCD = Ecd
	if global.GameDifficulty == 1:
		currentDMG = dmg
		firingCD = cd
	if global.GameDifficulty == 2:
		currentDMG = Hdmg
		firingCD = Hcd
	if global.GameDifficulty == 3:
		currentDMG = Ndmg
		firingCD = Ncd
	if global.GameDifficulty == 4:
		currentDMG = NPdmg
		firingCD = NPcd
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if player != null:
		look_at(player.global_position)
		rotation_degrees = wrap(rotation_degrees, 0 , 360)
		if rotation_degrees > 90 and rotation_degrees < 270:
			sprite.scale.y = -1
		else:
			sprite.scale.y = 1
			

func _physics_process(_delta: float) -> void:
	if player != null && player.health >= 0:
		
		if lasersightRay.is_colliding():
			var collisionPoint = lasersightRay.get_collision_point()
			var local_collPoint = to_local(collisionPoint)
			lasersight.points[1] = local_collPoint
		else:
			lasersight.points[1] = Vector2(2000,0)
		
		if canfire && mag >= 1 && not reloading:
			mag -= 1
			if global.SFX_Enabled:
				SoundFire.play()
			warnsprite.visible = false
			canfire = false
			player.gethitdmg = currentDMG
			player.died()
			if mag >= 1:
				get_tree().create_timer(firingCD).timeout.connect(resetfire)
		if mag <= 0 && not reloading:
			reloading = true
			get_tree().create_timer(reloadtime).timeout.connect(reloadingFinish)
			get_tree().create_timer(firingCD).timeout.connect(resetfire)
			get_tree().create_timer(firingCD-2.5).timeout.connect(warnImg)
			
	if player != null && player.health <= 0:
		lasersight.visible = false
		warning.visible = false


func resetfire():
	if sprite.visible:
		canfire = true
		
func reloadingFinish():
	reloading = false
	mag = maxammo
	
func warn():
	if visible == true:
		if global.SFX_Enabled:
			SoundWarn.play()
			
func warnImg():
	if visible == true:
		warnsprite.visible = true
		
func _on_detection_gun_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player") && player == null:
		get_tree().create_timer(firingCD).timeout.connect(resetfire)
		player = body
		get_tree().create_timer(firingCD-2.5).timeout.connect(warnImg)
		lasersight.visible = true
		if alreadysaid == false && visible:
			alreadysaid = true
			if global.SFX_Enabled:
				SoundAlert.play()
			get_tree().create_timer(firingCD-1).timeout.connect(warn)
		

#later make sniper lose sight of you when you leave his detection zone

func sizecheck():
	gunrange.scale.x = detectionrange.scale.x
	gunrange.scale.y = detectionrange.scale.y
