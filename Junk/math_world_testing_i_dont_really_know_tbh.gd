extends Node2D

#func R(u, v):
	#var pol = PI * u
	#var azi = 2 * PI * v
	#var r = 1
	#return Vector3(sin(pol)*cos(azi), sin(pol)*sin(azi), cos(pol)) * r
#
#func F(x, y, z):
	#return Vector3(z, y, x)
	
#var ustart = 0
#var uend = 1
#var vstart = 0
#var vend = 1
#var diff = 0.001

func R(u, v):
	var x = u * cos(v)
	var y = u * sin(v)
	return Vector3(x, y, 1-x*x-y*y)

func F(x, y, z):
	return Vector3(y, x, z)
	
var ustart = 0.0
var uend = 1.0
var vstart = 0.0
var vend = 2 * PI
var diff = 0.002

func calc_cross(u, v, u2, v2, currentR):
	return (R(u2, v) - currentR).cross(R(u, v2) - currentR)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var start_time = Time.get_ticks_usec()
	
	var uscale = diff
	var vscale = diff
	var uintercept = ustart
	var vintercept = vstart
	var ireps = int((uend-ustart)/diff)
	var jreps = int((vend-vstart)/diff)
	
	var sum = 0
	var u = uintercept
	for i in ireps:
		var v = vintercept
		var u2 = u + uscale
		for j in jreps:
			var v2 = v + vscale
			
			var currentR = R(u, v)
			
			sum += F(currentR.x, currentR.y, currentR.z).dot(calc_cross(u, v, u2, v2, currentR))
			
			v = v2
		u = u2
	

	var execution_time = Time.get_ticks_usec() - start_time
	#var sol = (4/3.0)*PI
	var sol = PI/2.0
	print("Flux: ", sum)
	print("Analytical solution: ", sol)
	print("Error: ", sum - sol)
	print("Time elapsed: ", execution_time/1000000.0, " s")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
