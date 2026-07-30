extends FunctionController

func R(u, v=0, w=0) -> Vector3:
	return Vector3(cos(u), sin(5*u), sin(u))
