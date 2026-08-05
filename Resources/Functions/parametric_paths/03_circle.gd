extends FunctionController

func _init() -> void:
	ustart = 0
	uend = 2*PI
	render_diff = 0.05
	calculation_diff = 0.05

func R(u, v=0, w=0) -> Vector3:
	return Vector3(cos(u), sin(u), 0) * 10
	
func P(u, v=0, w=0) -> float:
	return sin(u * 4)
