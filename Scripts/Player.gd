extends CharacterBody2D

class_name Player

enum PlayerMode {
	regular,
	nohands
}

enum SelectedWeapon {
	primary,
	secondary,
	melee,
	special
}

enum AmmoType {
	buckshot,
	example_thingies,
	slug,
	bullet
}

enum EmotionalState {
	vengeful,
	focused,
	stable,
	agony,
	disstressed,
	scared,
	unstable #depression
}

class inv_items:
	var gun: Node2D = null
	var wepons: PackedScene
	var slot_id: int
	var ammo_type: AmmoType
	var variant_id: int
	var weapon_type: SelectedWeapon
	func _init(p_weapon_type,p_ammo_type,p_wepons):
		self.weapon_type = p_weapon_type
		self.ammo_type = p_ammo_type
		self.wepons = p_wepons
	func setWepon(p_wepon : Node2D): self.gun = p_wepon
	func setSlots(p_slot_id,p_variant_id): self.slot_id = p_slot_id; self.variant_id = p_variant_id
	func getType() -> SelectedWeapon: return self.weapon_type
	func getSlots(): return [slot_id, variant_id]
	func getWepon() -> Node2D: return self.gun
	func getWepons() -> PackedScene: return self.wepons

var inventory_limitations
var inventory_size
var inventory_innited_wepon
var inventory
var inventory_slot = 0
var inventory_variation = 0
var inventory_loaded_item: inv_items
var inventory_loaded_wepon: Node2D

var is_dead: bool  = false

@onready var char_area: Area2D = $Area2D
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var shotty: Node2D
@onready var sound: AudioStreamPlayer2D = $Taunt
@onready var health_bar = $HealthBar
@onready var defence_bar = $DefenceBar
@onready var stamina_bar = $StaminaBar
@onready var HPNumb = $HPNumber #this isn't used anymore
@onready var tauntSong = $Taunt
@onready var levelmusic = $LevelMusic
@onready var emotionText = $Emotion
@onready var vengefulTheme = $VengefulMusic
@onready var talkingText = $Speak
@onready var Fade = $Fade

@export var lossScreen : PackedScene
@export_file var Current_scene
@export var LevelSong : AudioStreamMP3
@export_group("Debug mode")
@export var able_to_switch_mode: bool = false
@export_group("")

@export_group("Loadout")
@export var Primary_slots: int = 1
@export var Secondary_slots: int = 1
@export var Melee_slots: int = 3
@export var Special_slots: int = 1
@export_group("")

@export_group("Player things")
@export var Mental_State = EmotionalState.stable
@export var Player_Mode = PlayerMode.regular
@export var Show_Health: bool  = true
@export var Show_defence: bool  = true
@export var Gain_defense: bool  = true
@export var Show_stamina: bool  = true
@export var Has_stamina: bool  = true
@export var TauntName = "Taunt"
@export var Hands = "NX"
@export var can_wallclimb: bool  = true
@export var affected_by_mood: bool  = true
@export var allowInjuries: bool  = true
@export var triggerDicpiplie: bool  = true #gotta do this one
@export_group("")

@export_group("Stomping Enemies")
@export var min_stomp_deg: int = 35
@export var max_stomp_deg: int = 145
@export var stomp_y_vel: int = -150
@export var random_stomp_x_vel: int = 1200
@export_group("")

@export_group("Camera Sync")
@export var camera_sync: Camera2D
@export var should_camera_sync: bool = true
@export_group("")

@export_group("Vitals")
@export var MaxHealth: float = 21
@export var health: float = 21
@export var defence: float = 0.0
@export var CanHeal_viaTaunt: bool  = false
@export var HealthFromTaunting: float = 0.01
@export var HealWaitFromTaunt: float = 0.5
@export var Injury_recovery_time: float = 5.0
@export_group("")

@export_group("Damage")
@export var Stomp_DMG: float = 5.0
@export_group("")

@export_group("Other Stats")
@export var Coyote_Time: float = 0.3 #I want em to feel floaty when you use em. Maybe over exaturate the coyote time?
@export var SPEED: float = 100.0
@export var JUMP_VELOCITY: float = -400.0 #make sure it's in the minuses
@export var SpeedBoost: float = 2.0
@export var Maxstamina: float = 100.0
@export var Stamina_Gain: float = 21.0 #per second
@export var Stamina_Drain: float = 10.0 #per second
@export var Stamina_time_to_recover: float = 2.5 #cooldown before starting to regain stamina
@export var MinStaminaToRun: float = 10.0
@export var instantAim: bool  = true
@export var Aimspeed: float = 1500.0
@export var feelPain: bool  = true
@export var PainRecovery: float = 5.0
@export var MoodRecovery: float = 1.0
@export var climbspeed: float = 75.0
@export_group("")

@export_group("Multipliers")
@export var SpeedMulti: float = 1.0
@export var JumpMulti: float = 1.0
@export var DamageTakenMulti: float = 1.0
@export var AimSpeedMulti: float = 1.0
@export var DmgMulti: float = 1.0
@export var JumpDmgMulti: float = 1.0
@export var PainRecoveryMulti: float = 1.0
@export var MoodMulti: float = 1.0
@export var InjuryRecoveryMulti: float = 1.0
@export_group("")

@export_group("Character info")
@export var OC_name = "noox nooxie nooxTheHumanoid NX Noxious noxon nooxin'"
@export var description = "The main man himself."
@export var Unique_mechaic = "Each kill adds defence."
@export var calls_the_weapons = "toys" # Starting [calls_the_weapons]. It you set it to "tools" then it'll output "Starting tools"
@export_group("")

@export_group("Injuries")
@export var CanBeInjured: bool  = true
@export var Headtrauma: bool  = false
@export var InjuredArm: bool  = false
@export var BrokenArm: bool  = false
@export var InjuredLeg: bool  = false
@export var BrokenLeg: bool  = false
@export var minPain: float = 5.0 # was 17.0
@export var maxPain: float = 14.0 # was 25.0
@export_group("")

@export_group("InjuryTimer")
@export var HeadtraumaTime: float = 0.0
@export var InjuredArmTime: float = 0.0
@export var BrokenArmTime: float = 0.0
@export var InjuredLegTime: float = 0.0
@export var BrokenLegTime: float = 0.0
@export_group("")

var ExtraSpeed: float = 1.0
var InjuryAimSpeed: float = 1.0 #Used only for injuries
@export var PainAmount: float = 100.0
@export var mood: float = 100.0
@export var visibility: float = 0.0
@export var DMGBoost: float = 1.0 #from items and stuff
@export var TakeDMGBoost: float = 1.0 #from items and stuff
var HeadInjurySpeed: float = 1.0
var startedWithInstaAim: bool  = true
var IwantDuckOrTaunt = "none" #This is so fucking bad!!!
var taunting: bool = false
var Jump_Availabe: bool = true #Coyote time (Good for platformers)
var gethitdmg : float = 0.0
var healCD: bool  = false
var pausemovement: bool  = false
var current_stamina: float = 0.0
var stamina_cooldown_timer: float = 0.0
var Char_Running: bool  = false
var wallClimbing: float = false

var was_in_air: bool  = false
const Fall_punishment: float = 100.0
var starting_fall_y: float = 0.0

func Coyote_Timeout():
	Jump_Availabe = false

		
func enemy_stomped():
	starting_fall_y = global_position.y
	velocity.y = stomp_y_vel
	if Player_Mode == PlayerMode.nohands:
		pausemovement = true
		velocity.x = randi_range(-random_stomp_x_vel,random_stomp_x_vel)
		get_tree().create_timer(0.05).timeout.connect(unpause)

func unpause():
	pausemovement = false

func healplayer():
	healCD = false
	if IwantDuckOrTaunt == "taunt" && not is_dead:
		health += HealthFromTaunting
		health_bar.set_health(health)

func drain_stamina(delta):
	current_stamina -= delta * Stamina_Drain

func gain_stamina(delta):
	current_stamina += delta * Stamina_Gain
	
func pain_recovery(delta):
	PainAmount += (delta * PainRecovery) * PainRecoveryMulti
	
func mood_change(delta):
	mood += (delta * MoodRecovery) * MoodMulti

func moodUp(MoodUp):
	mood += (MoodUp * MoodRecovery) * MoodMulti

func tryHeal(HP: int):
	if global.fullDef:
		health += HP
		health_bar.set_health(health) 

func invInit(p_slots, p_size):
	# [enum.primary,enum.knife,enum.special]
	# [2,1,1]
	inventory_limitations = []
	inventory_size = []
	inventory = []
	inventory_innited_wepon = []
	for i in range(p_slots.size()):
		inventory_limitations.append(p_slots[i])
		inventory_size.append(p_size[i])
		inventory.append([])
		inventory_innited_wepon.append([])

func invAdd(p_item: inv_items) -> bool:
	if (p_item.getType() != inventory_limitations[inventory_slot]): return false
	if (inventory[inventory_slot].size() >= inventory_size[inventory_slot]): return false
	inventory[inventory_slot].append(p_item)
	inventory_innited_wepon[inventory_slot].append(false)
	p_item.setSlots(inventory_slot, inventory[inventory_slot].size() - 1)
	return true

func removeItem() -> inv_items:
	if invCheck(): return null
	var temp_item: inv_items = inventory[inventory_slot][inventory_variation];
	inventory[inventory_slot][inventory_variation] = null
	inventory_innited_wepon[inventory_slot][inventory_variation] = false
	return temp_item;

func getItem() -> inv_items:
	if invCheck(): return null
	var temp_item: inv_items = inventory[inventory_slot][inventory_variation]
	return temp_item;

func invLoadCurent():
	if invCheck(): return
	if inventory_loaded_wepon: inventory_loaded_wepon.visible = false
	inventory_loaded_item = inventory[inventory_slot][inventory_variation]
	inventory_loaded_wepon = null
	#checks if the wepon is relized and hides / loads it
	if (inventory_loaded_item.getWepon() == null):
		inventory_loaded_wepon = inventory_loaded_item.getWepons().instantiate()
		inventory_innited_wepon[inventory_slot][inventory_variation] = true
		inventory_loaded_item.setWepon(inventory_loaded_wepon)
		add_child(inventory_loaded_wepon)
	else:
		inventory_loaded_wepon = inventory_loaded_item.getWepon()
		inventory_loaded_wepon.visible = true
	# offsets
	inventory_loaded_wepon.char_skin(Hands)
	shotty = inventory_loaded_wepon
	
func invCheck():
	if inventory.size() <= inventory_slot: inventory_slot = 0
	if inventory_slot < 0: inventory.size() - 1
	if inventory[inventory_slot].size() <= inventory_variation: inventory_variation = 0
	if inventory_variation < 0: inventory[inventory_slot].size() - 1
	if (inventory[inventory_slot] && inventory[inventory_slot][inventory_variation]): return false
	else: return true
	
