extends Node2D

@onready var sprite = $Gun
@onready var muzzle: Marker2D = $Marker2D
@onready var gunrange = $"../DetectionGun"
@onready var detectionrange = $"../Detection"
@onready var firesound = $Fire

@export var currentDMG : float = 0.4 # was 1 DMG
@export var firingCD = 0.4
@export var mag = 15
@export var reloadtime = 4.0
@export_group("easy mode")
@export var Edmg = 0.2
@export var Ecd = 0.7
@export var Erel = 6.5
@export_group("")
@export_group("normal mode")
@export var dmg = 0.4
@export var cd = 0.4
@export var rel = 4.0
@export_group("")
@export_group("hard mode")
@export var Hdmg = 0.5
@export var Hcd = 0.3
@export var Hrel = 3.5
@export_group("")
@export_group("nooxin mode")
@export var Ndmg = 0.55
@export var Ncd = 0.25
@export var Nrel = 2.0
@export_group("")
@export_group("nooxin+ mode")
@export var NPdmg = 0.65
@export var NPcd = 0.1
@export var NPrel = 1.25
@export_group("")
var canfire = false
var reloading = false
var player = null
var maxammo = mag

const BULLET = preload('res://things/bullet.tscn')
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_tree().create_timer(0.01).timeout.connect(sizecheck)
	if global.GameDifficulty == 0:
		currentDMG = Edmg
		firingCD = Ecd
		reloadtime = Erel
	if global.GameDifficulty == 1:
		currentDMG = dmg
		firingCD = cd
		reloadtime = rel
	if global.GameDifficulty == 2:
		currentDMG = Hdmg
		firingCD = Hcd
		reloadtime = Hrel
	if global.GameDifficulty == 3:
		currentDMG = Ndmg
		firingCD = Ncd
		reloadtime = Nrel
	if global.GameDifficulty == 4:
		currentDMG = NPdmg
		firingCD = NPcd
		reloadtime = NPrel
	sprite.play("default")
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if player != null:
		look_at(player.global_position)
		rotation_degrees = wrap(rotation_degrees, 0 , 360)
		if rotation_degrees > 90 and rotation_degrees < 270:
			position = Vector2(5,9)
			#sprite.flip_h = true
			sprite.flip_v = true
		else:
			position = Vector2(-5,9)
			sprite.flip_h = false
			sprite.flip_v = false
			

func _physics_process(_delta: float) -> void:
	if player != null && player.health >= 0:
		if canfire && mag >= 1 && not reloading:
			mag -= 1
			canfire = false
			if global.SFX_Enabled:
				firesound.play()
			var bullet_instance = BULLET.instantiate()
			get_tree().root.add_child(bullet_instance)
			bullet_instance.global_position = muzzle.global_position
			bullet_instance.rotation = rotation
			bullet_instance.damagVal(currentDMG)
			if mag >= 1:
				get_tree().create_timer(firingCD).timeout.connect(resetfire)
		if mag <= 0 && not reloading:
			reloading = true
			get_tree().create_timer(reloadtime).timeout.connect(reloadingFinish)
			get_tree().create_timer(firingCD).timeout.connect(resetfire)
		
func resetfire():
	if sprite.visible:
		canfire = true
		
func reloadingFinish():
	reloading = false
	mag = maxammo

func _on_detection_gun_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player") && player == null:
		get_tree().create_timer(firingCD).timeout.connect(resetfire)
		player = body

func sizecheck():
	gunrange.scale.x = detectionrange.scale.x
	gunrange.scale.y = detectionrange.scale.y
