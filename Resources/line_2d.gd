extends Line2D

@export var scroll_speed: float = 1
@export var scroll_offset: float = 1

var test_timer = 0
func _process(delta: float) -> void:
	var index = -1
	for point in points:
		index += 1
		points[index].x -= delta * scroll_speed 
		if points[index].x < 0:
			remove_point(index)
			index -= 1
	test(delta)

func test(delta):
	test_timer -= delta
	if (test_timer < 0):
		test_timer = 0.1
		createPoint(Vector2(0, randi_range(-100,100)))

func createPoint(x : Vector2):
	print(x + Vector2.RIGHT * scroll_offset)
	add_point(x + Vector2.RIGHT * scroll_offset)
