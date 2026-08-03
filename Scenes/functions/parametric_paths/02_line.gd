extends FunctionController

func _init() -> void:
	ustart = -10.0
	uend = 10.0
	diff = 1

func R(u, v=0, w=0) -> Vector3:
	return Vector3(u, u, 0)
	
func P(u, v=0, w=0) -> float:
	return cos(u)
