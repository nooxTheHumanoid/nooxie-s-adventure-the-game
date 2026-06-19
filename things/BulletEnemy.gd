extends Node2D

class_name EnemyBullet

@onready var bullet_area: Area2D = $Area2D
@onready var detector = $Area2D/Detector
@onready var sprite = $BulletSprite
var damagetoenemy: float = 1.0
var bulletlifetime: int = 5
@export var health: float = 1.0
const SPEED: int = 300
@export var reversed = false
@export var harmOthers = false
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _ready():
	get_tree().create_timer(bulletlifetime).timeout.connect(bulletgone)
		
func _process(delta: float) -> void:
	if reversed:
		position -= transform.x * SPEED * delta
		sprite.scale.x = -1
		sprite.scale.y = -1
	else:
		position += transform.x * SPEED * delta
		sprite.scale.x = 1
		sprite.scale.y = 1
	if detector.is_colliding():
		bulletgone()

func damagVal(dmg):
	damagetoenemy = dmg
	
func healthVal(hp):
	health = hp
	
func bulletgone():
	queue_free()
	
func bulReverse(state):
	reversed = state
	
func harmother(state):
	harmOthers = state
	
func bulisReverse():
	return reversed

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
		

func handle_en_collision(enemy: Enemy):
	if enemy == null:
		return
	
	if enemy.health >= 0:
		enemy.hurtEnemy(damagetoenemy)
		
func handle_en_collision2(enemy: EnemyMafia):
	if enemy == null:
		return
	
	if enemy.health >= 0:
		enemy.hurtEnemy(damagetoenemy)
		
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		handle_enemy_collision(body)
		

func _on_area_2d_area_entered(area: Area2D) -> void:
	if harmOthers:
		if area is Enemy:
			handle_en_collision(area)
		if area is EnemyMafia:
			handle_en_collision2(area)
		if area.get_parent() is EnemyBullet:
			handle_bullet_collision(area.get_parent())
	if area.get_parent() is PlayerBullet:
		handle_bullet_collision(area.get_parent())
