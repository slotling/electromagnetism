extends Node2D

# COMPARING METHODS:
# - central vs cornered
# - analytical vs nonanalytical R partials for integrand
# - corner averaging vs center value
# ON MULTIPLE FUNCTIONS


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
	
func R_u(u, v):
	var x = cos(v)
	var y = sin(v)
	return Vector3(x, y, 1 - 2*u)
	
func R_v(u, v):
	var x = -u * sin(v)
	var y = u * cos(v)
	return Vector3(x, y, 0)

func F(x, y, z):
	return Vector3(y, x, z)
	
var ustart = 0.0
var uend = 1.0
var vstart = 0.0
var vend = 2 * PI
var diff = 0.01 # time taken scales with approx (1/diff)^2
var finediff = 0.0001 # for checking

func calculate_analytical_integral(u_a, u_b, v_a, v_b):
	return -1.0/4.0 * (u_b**4 - u_a**4) * (cos(2*v_b) - cos(2*v_a) + v_b - v_a) + 1.0/2.0 * (u_b**2 - u_a**2) * (v_b - v_a)

func calculate_integrand_using_analytical_R_partials(u, v, uscale, vscale):
	var currentR = R(u, v)
	var diffCross = R_u(u, v).cross(R_v(u, v)) * uscale * vscale
	var value = Vector3.ZERO
	#for xdm in [-1, 1]:
		#for ydm in [-1, 1]:
			#for zdm in [-1, 1]:
				#value += F(currentR.x + finediff * xdm, currentR.y + finediff * ydm, currentR.z + finediff * zdm)
	#value /= 8.0
	value = F(currentR.x + finediff, currentR.y + finediff, currentR.z)
	return value.dot(diffCross)

func calculate_integrand(u, v, u2, v2):
	var currentR = R(u, v)
	var newRu = R(u2, v)
	var newRv = R(u, v2)
	var diffRu = newRu - currentR
	var diffRv = newRv - currentR
	var diffCross = diffRu.cross(diffRv)
	var value = 0
	#for xdm in [-1, 1]:
		#for ydm in [-1, 1]:
			#for zdm in [-1, 1]:
				#value += F(currentR.x + finediff * xdm, currentR.y + finediff * ydm, currentR.z * zdm)
	#value /= 8.0
	#value = F(currentR.x + finediff, currentR.y + finediff, currentR.z)
	return value.dot(diffCross)

func calculate(use_analytical_R_partials=true):
	var uscale = diff
	var vscale = diff
	var ufinescale = finediff
	var vfinescale = finediff
	var uintercept = ustart + diff/2 # locate at center of patch
	var vintercept = vstart + diff/2 # locate at center of patch
	
	var sum = 0
	var u = uintercept
	
	var integrandDifferences_u = []
	var integrandDifferences_v = []
	
	# FIRST PASS: unmodified numerical quadrature
	var areas = 0
	while u < uend:
		var v = vintercept
		var u2 = u + uscale
		while v < vend:
			var v2 = v + vscale
			var integrand = calculate_integrand(u, v, u2, v2) if not use_analytical_R_partials else calculate_integrand_using_analytical_R_partials(u, v, uscale, vscale)

			sum += integrand
			
			v = v2
			areas += 1
		
		u = u2
	
	return {"sum": sum, "second_sum": sum, "areas": areas, "extra_areas": 0}

func calculate_and_report(sol, use_analytical_R_partials):
	var start_time = Time.get_ticks_usec()
	var results = calculate(use_analytical_R_partials)
	var execution_time = Time.get_ticks_usec() - start_time

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var sol = calculate_analytical_integral(ustart, uend, vstart, vend)
	calculate_and_report(sol, true)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
