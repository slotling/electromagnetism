extends FunctionController

func _init() -> void:
	ustart = -1.0
	uend = 1.0
	vstart = -1.0
	vend = 1.0
	render_diff = 0.1

func R(u, v=0, w=0) -> Vector3:
	return Vector3(u, v, 0.5 * u + 1)
