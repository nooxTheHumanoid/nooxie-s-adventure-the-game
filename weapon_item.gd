extends Node2D

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

class inv_items:
	var gun: Node2D = null
	var wepons: PackedScene
	var slot_id: int
	var ammo_type: AmmoType
	var variant_id: int
	var ammo: int
	var weapon_type: SelectedWeapon
	func _init(p_weapon_type,p_ammo_type,p_wepons):
		self.weapon_type = p_weapon_type
		self.ammo_type = p_ammo_type
		self.wepons = p_wepons
		#if p_ammo != null:
			#self.ammo = p_ammo
	func setWepon(p_wepon : Node2D): self.gun = p_wepon
	func setSlots(p_slot_id,p_variant_id): self.slot_id = p_slot_id; self.variant_id = p_variant_id
	func getType() -> SelectedWeapon: return self.weapon_type
	func getSlots(): return [slot_id, variant_id]
	func getAmmo(): return self.ammo
	func getWepon() -> Node2D: return self.gun
	func getWepons() -> PackedScene: return self.wepons

@onready var area = $Area2D
@onready var text = $Label

var player
var player_nearby: bool = false

func _ready() -> void:
	text.visible = false
	

func _process(_delta: float) -> void:
	if player_nearby:
		if Input.is_action_just_pressed("interact"):
			interact()
		

func interact():
	player.ItemAdd(SelectedWeapon.primary, AmmoType.slug, global.Primaries[0])


func _on_area_2d_body_entered(body: Node2D) -> void:
	text.visible = true
	player_nearby = true
	if body.is_in_group("Player") && player == null:
		player = body


func _on_area_2d_body_exited(body: Node2D) -> void:
	text.visible = false
	player_nearby = false
	if body.is_in_group("Player") && player == null:
		player = body
