extends AnimatedSprite2D

class_name ShottyAnimator

var Handsskin = "NX"

func loadSkin():
	#play("default")
	#Handsskin = "NX"
	play("%s_default" % Handsskin)

func fireshotty():
	#play("Fire")
	#Handsskin = "NX"
	play("%s_Fire" % Handsskin)

func skin(yes):
	Handsskin = yes
