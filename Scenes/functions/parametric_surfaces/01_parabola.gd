extends FunctionController

func R(u, v=0, w=0) -> Vector3:
	var x = u * cos(v)
	var y = u * sin(v)
	return Vector3(x, y, 1-x*x-y*y)
