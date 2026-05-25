extends ProgressBar


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	value = global.tempkills*5


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	value = global.tempkills*5
	if value >= 101:
		value = 100
