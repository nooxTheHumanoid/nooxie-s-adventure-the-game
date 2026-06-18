extends Node2D

class_name PlayerBullet

@onready var detector = $Area2D/Detector

var damagetoenemy: float = 1.0
var bulletlifetime: int = 5
const SPEED: int = 300
@export var health: float = 2.0

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
		
func handle_enemy_collision(enemy: Enemy):
	if enemy == null:
		return
	
	if enemy.health >= 0:
		enemy.hurtEnemy(damagetoenemy)
		
func handle_enemy_collision2(enemy: EnemyMafia):
	if enemy == null:
		return
	
	if enemy.health >= 0:
		enemy.hurtEnemy(damagetoenemy)

func handle_bullet_collision(bullet: Node2D):
	if bullet == null:
		return
	
	if bullet != null:
		bullet.dmgBullet(health)

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area is Enemy:
		handle_enemy_collision(area)
	if area is EnemyMafia:
		handle_enemy_collision2(area)
	if area.get_parent() is EnemyBullet:
		handle_bullet_collision(area.get_parent())
		
