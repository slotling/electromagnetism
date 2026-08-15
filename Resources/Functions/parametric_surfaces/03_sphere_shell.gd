extends FunctionController

var radius = 1

func _init() -> void:
	ustart = -2*PI
	uend = 0
	vstart = -PI
	vend = 0
	render_diff = 0.1
	calculation_diff = 0.01

func R(u, v=0, w=0) -> Vector3:
	var x = sin(v) * cos(u)
	var y = sin(v) * sin(u)
	var z = cos(v)
	return Vector3(x, y, z) * 1
	
func R_u(u, v=0) -> Vector3:
	var dxdu = -sin(v) * sin(u)
	var dydu = sin(v) * cos(u)
	var dzdu = 0
	return radius * Vector3(dxdu, dydu, dzdu)
	
func R_v(u, v) -> Vector3:
	var dxdv = cos(v) * cos(u)
	var dydv = cos(v) * sin(u)
	var dzdv = -sin(v)
	return radius * Vector3(dxdv, dydv, dzdv)
	
