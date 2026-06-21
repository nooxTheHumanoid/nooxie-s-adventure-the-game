extends CharacterBody2D

func _ready() -> void:
	velocity = Vector2(200,150)
	
func _physics_process(delta: float) -> void:
	var collision = move_and_collide(velocity * delta)
	
	if collision:
		var normal = collision.get_normal()
		
		velocity = velocity.bounce(normal)
		var color1 = randf_range(0.00,1.00)
		var color2 = randf_range(0.00,1.00)
		var color3 = randf_range(0.00,1.00)
		$Sprite2D.self_modulate = Color(color1, color2, color3, 1.0)
