extends AnimatedSprite2D

class_name ShottyAnimator

var Handsskin = "NX"

func loadSkin():
	#play("default")
	play("%s_default" % Handsskin)

func fireshotty():
	#play("Fire")
	play("%s_Fire" % Handsskin)

func skin(yes):
	Handsskin = yes
