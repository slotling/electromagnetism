extends FunctionController

func _init() -> void:
	ustart = -10.0
	uend = 10.0

func R(u, v=0, w=0) -> Vector3:
	return Vector3(cos(u), sin(5*u), sin(u))
