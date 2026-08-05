extends FunctionController

func _init() -> void:
	ustart = 0.0
	uend = 1
	vstart = 0.0
	vend = 2*PI
	render_diff = 0.1
	calculation_diff = 0.002

func R(u, v=0, w=0) -> Vector3:
	var x = u * cos(v)
	var y = u * sin(v)
	return Vector3(x, y, 1-x*x-y*y)
	
func R_u(u, v=0) -> Vector3:
	var x = cos(v)
	var y = sin(v)
	return Vector3(x, y, 1 - 2*u)
	
func R_v(u, v) -> Vector3:
	var x = -u * sin(v)
	var y = u * cos(v)
	return Vector3(x, y, 0)
