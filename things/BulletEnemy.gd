extends Node2D

class_name EnemyBullet

@onready var bullet_area: Area2D = $Area2D
@onready var detector = $Area2D/Detector

var damagetoenemy: float = 1.0
var bulletlifetime: int = 5
@export var health: float = 1.0
const SPEED: int = 300
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _ready():
	get_tree().create_timer(bulletlifetime).timeout.connect(bulletgone)
		
func _process(delta: float) -> void:
	position += transform.x * SPEED * delta
	if detector.is_colliding():
		bulletgone()

func damagVal(dmg):
	damagetoenemy = dmg
	
func healthVal(hp):
	health = hp
	
func bulletgone():
	queue_free()

func dmgBullet(hp):
	if hp <= 0.0:
		pass
	else:
		health -= hp
		if health <= 0.0:
			bulletgone()

func handle_enemy_collision(player: Player):
	if player == null:
		return
	
	if player.health >= 0.0:
		player.gethitdmg = damagetoenemy
		player.died()

func handle_bullet_collision(bullet: Node2D):
	if bullet == null:
		return
	
	if bullet != null:
		bullet.dmgBullet(health)
		
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		handle_enemy_collision(body)
		

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.get_parent() is PlayerBullet:
		handle_bullet_collision(area.get_parent())
