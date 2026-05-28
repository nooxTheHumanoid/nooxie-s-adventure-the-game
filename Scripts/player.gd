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
	focused,
	stable,
	agony,
	disstressed,
	scared,
	unstable #depression
}

class inv_items:
	var weapon_type: SelectedWeapon
	var dmg: float
	var attack_speed: float
	var ammo_type: AmmoType
	var wepons: PackedScene
	var slot_id: int
	var variant_id: int
	var offset: Vector2 = Vector2.ZERO
	var offset_crouch: Vector2 = Vector2.ZERO
	func _init(p_weapon_type,p_dmg,p_attack_speed,p_ammo_type,p_wepons):
		self.weapon_type = p_weapon_type
		self.dmg = p_dmg
		self.attack_speed = p_attack_speed
		self.ammo_type = p_ammo_type
		self.wepons = p_wepons
	func setSlots(p_slot_id,p_variant_id): variant_id = p_slot_id; variant_id = p_variant_id
	func setOffsets(p_offset, p_offset_crouch): offset = p_offset; offset_crouch = p_offset_crouch
	func getSlots(): return [slot_id, variant_id]
	func getType() -> SelectedWeapon: return weapon_type
	func getWepons() -> PackedScene: return wepons
	func getOffsets(): return [offset, offset_crouch]
	func getDmg() -> float: return dmg
	func getAttackspeed() -> float: return attack_speed

@export var temp_preload: PackedScene
@export var temp_preload_2: PackedScene
@export var temp_preload_3: PackedScene
var inventory_limitations
var inventory_size
var inventory
var inventory_slot = 0
var inventory_variation = 0
var inventory_loaded_item: inv_items
var inventory_loaded_wepon: Node2D

var is_dead = false

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

@export var Coyote_Time: float = 0.3 #I want em to feel floaty when you use em. Maybe over exaturate the coyote time?

@export var lossScreen : PackedScene
@export_file var Current_scene
@export var LevelSong : AudioStreamMP3
@export_group("Debug mode")
@export var able_to_switch_mode: bool = false
@export_group("")

@export_group("Player things")
@export var Mental_State = EmotionalState.stable
@export var Player_Mode = PlayerMode.regular
@export var Show_Health = true
@export var Show_defence = true
@export var Gain_defense = true
@export var Show_stamina = true
@export var Has_stamina = true
@export var TauntName = "Taunt"
@export var Hands = "NX"
@export_group("")

@export_group("Stomping Enemies")
@export var min_stomp_deg = 35
@export var max_stomp_deg = 145
@export var stomp_y_vel = -150
@export var random_stomp_x_vel = 1200
@export_group("")

@export_group("Camera Sync")
@export var camera_sync: Camera2D
@export var should_camera_sync: bool = true
@export_group("")

@export_group("Vitals")
@export var MaxHealth = 21
@export var health = 21
@export var defence = 0.0
@export var CanHeal_viaTaunt = false
@export var HealthFromTaunting = 0.01
@export var HealWaitFromTaunt = 0.5
@export var Injury_recovery_time = 5.0
@export_group("")

@export_group("Damage")
@export var Stomp_DMG = 5.0
@export_group("")

@export_group("Other Stats")
@export var SPEED = 100.0
@export var JUMP_VELOCITY = -400.0 #make sure it's in the minuses
@export var SpeedBoost = 2.0
@export var Maxstamina = 100.0
@export var Stamina_Gain = 21.0 #per second
@export var Stamina_Drain = 10.0 #per second
@export var Stamina_time_to_recover = 2.5 #cooldown before starting to regain stamina
@export var MinStaminaToRun = 10.0
@export_group("")

@export_group("Character info")
@export var OC_name = "noox nooxie nooxTheHumanoid NX Noxious noxon nooxin'"
@export var description = "The main man himself."
@export var Unique_mechaic = "Each kill adds defence."
@export var calls_the_weapons = "toys" # Starting [calls_the_weapons]. It you set it to "tools" then it'll output "Starting tools"
@export_group("")

@export_group("Injuries")
@export var CanBeInjured = true
@export var Headtrauma = false
@export var InjuredArm = false
@export var BrokenArm = false
@export var InjuredLeg = false
@export var BrokenLeg = false
@export_group("")

var ExtraSpeed = 1.0
var IwantDuckOrTaunt = "none" #This is so fucking bad!!!
var taunting: bool = false
var Jump_Availabe: bool = true #Coyote time (Good for platformers)
var gethitdmg : float = 0.0
var healCD = false
var pausemovement = false
var current_stamina = 0.0
var stamina_cooldown_timer = 0
var Char_Running = false

func _ready():
	invInit([SelectedWeapon.primary, SelectedWeapon.secondary, SelectedWeapon.melee, SelectedWeapon.special], [1, 1, 3, 1])
	inventory_slot = 0; inventory_variation = 0
	if !invAdd(inv_items.new(SelectedWeapon.primary, 1, 0.5, AmmoType.slug, temp_preload)):
		print("failed to add item")
	inventory_slot = 1; inventory_variation = 0 #changes slot to mag_12
	if !invAdd(inv_items.new(SelectedWeapon.secondary, 4, 2.1, AmmoType.bullet, temp_preload_2)):
		print("failed to add item")
	inventory_slot = 3; inventory_variation = 0 #changes slot to OPGun
	if !invAdd(inv_items.new(SelectedWeapon.special, 1, 0.01, AmmoType.slug, temp_preload_3)):
		print("failed to add item")
	inventory_slot = 0; inventory_variation = 0
	invLoadCurent()
	global.enemies = 0
	global.tempkills = defence/5
	levelmusic.stream = LevelSong
	if global.Music_Enabled:
		levelmusic.playing = true
	pausemovement = false
	if Show_Health:
		health_bar.visible = true
	else:
		health_bar.visible = false
	if Show_defence:
		defence_bar.visible = true
	else:
		defence_bar.visible = false
	if Show_stamina:
		stamina_bar.visible = true
	else:
		stamina_bar.visible = false
	if health >= MaxHealth:
		MaxHealth = health
	stamina_bar.max_value = Maxstamina
	stamina_bar.value = Maxstamina
	current_stamina = Maxstamina
	health_bar.init_health(MaxHealth)
	if shotty:
		shotty.char_skin(Hands)

func _process(delta):
	if Input.is_action_just_pressed("HoldFire"):
		if global.holdfire:
			global.holdfire = false
		else:
			global.holdfire = true
	if Input.is_action_just_pressed("Suicide") && is_dead == false && global.disable_suicide == false:
		health = 0.0
		died()
	if Gain_defense:
		defence = global.tempkills*5
	if defence >= 101:
		defence = 100
		
	if health >= MaxHealth:
		health = MaxHealth

	if Has_stamina:	
		stamina_bar.value = current_stamina / Maxstamina * 100
		current_stamina = clamp(current_stamina, 0, Maxstamina)
		#if current_stamina <= MinStaminaToRun:
			#stamina_bar.set("theme_override_styles/fill",Color(1.0, 0.0, 0.0, 1.0))
		#else:
			#stamina_bar.set("theme_override_styles/fill",Color(0.81, 0.66, 0.0, 1.0))

		#TODO make this stamina be dependand on delta and _process
		# with stamina_cooldown_timer
		if Char_Running && current_stamina > 0:
			drain_stamina(delta)
		if !Char_Running && stamina_cooldown_timer <= 0 && current_stamina <= Maxstamina:
			gain_stamina(delta)
		if current_stamina <= 0:
			Char_Running = false
		if stamina_cooldown_timer > 0:
			stamina_cooldown_timer -= delta
		
		#print("Is running?: ",Char_Running," Stamina: ",current_stamina," stamin_timer_sent: ",stamin_timer_sent," can_regen_stamina: ",can_regen_stamina)

	if health >= 0 && not is_dead && camera_sync:
		if global_position.x > camera_sync.global_position.x && should_camera_sync == true:
			camera_sync.global_position.x = global_position.x
		if global_position.x < camera_sync.global_position.x && should_camera_sync == true:
			camera_sync.global_position.x = global_position.x
		if global_position.y > camera_sync.global_position.y && should_camera_sync == true:
			camera_sync.global_position.y = global_position.y
		if global_position.y < camera_sync.global_position.y && should_camera_sync == true:
			camera_sync.global_position.y = global_position.y
	
	if get_global_mouse_position().x < global_position.x && Player_Mode == PlayerMode.nohands and taunting == false:
		sprite.flip_h = true
	else:
		sprite.flip_h = false
	
	if IwantDuckOrTaunt == "taunt":
		if CanHeal_viaTaunt == true && healCD == false:
			healCD = true
			get_tree().create_timer(HealWaitFromTaunt).timeout.connect(healplayer)
		
	if CanBeInjured == false:
		BrokenArm = false
		InjuredArm = false
		BrokenLeg = false
		InjuredLeg = false


func _physics_process(delta: float) -> void:
		
		
	if not is_on_floor():
		if Jump_Availabe:
			get_tree().create_timer(Coyote_Time).timeout.connect(Coyote_Timeout)
		
		velocity += get_gravity() * delta
	else:	
		Jump_Availabe = true

	
	if Input.is_action_pressed("jump") and Jump_Availabe and taunting == false:
		velocity.y = JUMP_VELOCITY
		Jump_Availabe = false
	

	var direction := Input.get_axis("left", "right")
	if Input.is_action_pressed("sprint") && ((current_stamina > 0 && Char_Running) || (current_stamina > MinStaminaToRun && !Char_Running)) && BrokenLeg == false:
		#TODO make the sprint only posible when stamina exists and is above the stamina start amount
		ExtraSpeed = SpeedBoost
		Char_Running = true
		stamina_cooldown_timer = Stamina_time_to_recover
	else:
		ExtraSpeed = 1.0
		Char_Running = false
	
	if Input.is_action_just_pressed("change action"):
		if able_to_switch_mode == true:
			if Player_Mode == PlayerMode.regular:
				Player_Mode = PlayerMode.nohands
			else:
				Player_Mode = PlayerMode.regular	
	
	
	if Input.is_action_pressed("down") and is_on_floor() and taunting == false:
		IwantDuckOrTaunt = "duck"
		ExtraSpeed = 0
	elif Input.is_action_just_pressed("taunt") and is_on_floor() and taunting == false:
		IwantDuckOrTaunt= "taunt"
		taunting = true
	elif taunting == false:
		IwantDuckOrTaunt = "none"
	elif Input.is_action_just_pressed("taunt") and is_on_floor() and taunting == true:
		IwantDuckOrTaunt = "none"
		taunting = false

	if direction && IwantDuckOrTaunt == "none" && pausemovement == false:
		if BrokenLeg:
			velocity.x = (direction * SPEED * ExtraSpeed) * 0.25
		elif InjuredLeg:
			velocity.x = (direction * SPEED * ExtraSpeed) * 0.5
		else:
			velocity.x = direction * SPEED * ExtraSpeed
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	if IwantDuckOrTaunt != "taunt":
		if levelmusic.stream_paused == true:
			if global.Music_Enabled:
				tauntSong.playing = false
				levelmusic.stream_paused = false
	else:
		if tauntSong.playing == false:
			if global.Music_Enabled:
				tauntSong.playing = true
				levelmusic.stream_paused = true
	
	sprite.char_state(IwantDuckOrTaunt)
	sprite.WhatTaunt(TauntName)
	sprite.trigger_animation(velocity,direction,Player_Mode)
	if shotty:
		shotty.modenotifforguns(Player_Mode)
		shotty.state_char_anim(IwantDuckOrTaunt)
		shotty.dmgnumber(inventory_loaded_item.getDmg())
		shotty.cdnumber(inventory_loaded_item.getAttackspeed())
		if shotty.mayIswap() == true:
			if Input.is_action_just_pressed("slot1"):
				inventory_slot = 0; inventory_variation = 0 #changes slot to Primary
				invLoadCurent()
			elif Input.is_action_just_pressed("slot2"):
				inventory_slot = 1; inventory_variation = 0 #changes slot to Secondary
				invLoadCurent()
			elif Input.is_action_just_pressed("slot3"):
				inventory_slot = 2; inventory_variation = 0 #changes slot to Melee
				invLoadCurent()
			elif Input.is_action_just_pressed("slot4"):
				inventory_slot = 3; inventory_variation = 0 #changes slot to Special
				invLoadCurent()
	move_and_slide()


func Coyote_Timeout():
	Jump_Availabe = false


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area is Enemy:
		handle_enemy_collision(area)
	if area is EnemyMafia:
		handle_enemy_collision2(area)
		
func handle_enemy_collision(enemy: Enemy):
	if enemy == null && is_dead == false:
		return
	
	var angle_of_collison = rad_to_deg(position.angle_to_point(enemy.position))
	
	if angle_of_collison > min_stomp_deg && max_stomp_deg > angle_of_collison:
		enemy.hurtEnemy(Stomp_DMG)
		enemy_stomped()
	else:
		gethitdmg = enemy.damage
		died()
		
func handle_enemy_collision2(enemy: EnemyMafia):
	if enemy == null && is_dead == false:
		return
	
	var angle_of_collison = rad_to_deg(position.angle_to_point(enemy.position))
	
	if angle_of_collison > min_stomp_deg && max_stomp_deg > angle_of_collison:
		enemy.hurtEnemy(Stomp_DMG/2) #because mafia is stronger in this game
		enemy_stomped()
	else:
		gethitdmg = enemy.damage
		died()
		
func enemy_stomped():
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

func died():
	health -= gethitdmg-(gethitdmg*(defence*0.01))
	global.tempkills = 0
	health_bar.set_health(health) 
	if health <= 0:
		is_dead = true
		defence_bar.queue_free()
		stamina_bar.visible = false
		sprite.play("Death")
		char_area.set_collision_layer_value(1,false)
		char_area.set_collision_mask_value(3,false)
		set_collision_layer_value(1,false)
		set_collision_mask_value(3,false)
		set_physics_process(false)
		
		tauntSong.playing = false
		levelmusic.playing = false
		Player_Mode = PlayerMode.regular
		if shotty:
			shotty.modenotifforguns(Player_Mode)
		var death_tween = get_tree().create_tween()
		death_tween.tween_property(self, "position", position + Vector2(0, -48), .5)
		death_tween.chain().tween_property(self,"position", position + Vector2(0,256),1)
		death_tween.tween_callback(func ():
			var screen = lossScreen.instantiate()
			screen.Level = Current_scene
			get_parent().add_child(screen))

func invInit(p_slots, p_size):
	# [enum.primary,enum.knife,enum.special]
	# [2,1,1]
	inventory_limitations = []
	inventory = []
	inventory_size = []
	for i in range(p_slots.size()):
		inventory_limitations.append(p_slots[i])
		inventory_size.append(p_size[i])
		inventory.append([])

func invAdd(p_item: inv_items) -> bool:
	if (p_item.getType() != inventory_limitations[inventory_slot]): return false
	if (inventory[inventory_slot].size() >= inventory_size[inventory_slot]): return false
	inventory[inventory_slot].append(p_item)
	p_item.setSlots(inventory_slot, inventory[inventory_slot].size() - 1)
	return true

func removeItem() -> inv_items:
	if !(inventory[inventory_slot] && inventory[inventory_slot][inventory_variation]): return null
	var temp_item: inv_items = inventory[inventory_slot][inventory_variation];
	inventory[inventory_slot][inventory_variation] = null;
	return temp_item;

func getItem() -> inv_items:
	if !(inventory[inventory_slot] && inventory[inventory_slot][inventory_variation]): return null
	var temp_item: inv_items = inventory[inventory_slot][inventory_variation]
	return temp_item;

func invLoadCurent():
	if !(inventory[inventory_slot] && inventory[inventory_slot][inventory_variation]): return
	if inventory_loaded_wepon: inventory_loaded_wepon.queue_free()
	inventory_loaded_item = inventory[inventory_slot][inventory_variation]
	inventory_loaded_wepon = inventory_loaded_item.getWepons().instantiate()
	add_child(inventory_loaded_wepon)
	print(inventory_loaded_item.getOffsets()[0])
	inventory_loaded_wepon.position = inventory_loaded_item.getOffsets()[0]
	shotty = inventory_loaded_wepon
	if shotty:
		shotty.char_skin(Hands)
