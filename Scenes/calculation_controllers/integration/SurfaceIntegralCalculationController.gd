extends CalculationController
class_name SurfaceIntegralCalculationController

# attach as child of parametric surface

@onready var SurfaceScriptInstance: FunctionController
@onready var FieldScriptInstance: FunctionController

func R(u, v):
	return SurfaceScriptInstance.R(u, v)
	
func R_u(u, v):
	return SurfaceScriptInstance.R_u(u, v)
	
func R_v(u, v):
	return SurfaceScriptInstance.R_v(u, v)

func F(x, y, z):
	return FieldScriptInstance.F(x, y, z)

func calculate_integrand_using_analytical_R_partials(u, v, uscale, vscale):
	var currentR = R(u, v)
	var diffCross = R_u(u, v).cross(R_v(u, v)) * uscale * vscale
	var value = F(currentR.x, currentR.y, currentR.z)
	return value.dot(diffCross)

func calculate_integrand(u, v, u2, v2):
	var currentR = R(u, v)
	var newRu = R(u2, v)
	var newRv = R(u, v2)
	var diffRu = newRu - currentR
	var diffRv = newRv - currentR
	var diffCross = diffRu.cross(diffRv)
	var value = F(currentR.x, currentR.y, currentR.z)
	return value.dot(diffCross)

func calculate_full_integral(use_analytical_R_partials=true):
	var uscale = SurfaceScriptInstance.calculation_diff
	var vscale = SurfaceScriptInstance.calculation_diff
	var uintercept = SurfaceScriptInstance.ustart + SurfaceScriptInstance.calculation_diff/2 # locate at center of patch
	var vintercept = SurfaceScriptInstance.vstart + SurfaceScriptInstance.calculation_diff/2 # locate at center of patch
	
	var sum = 0
	var u = uintercept
	
	var integrandDifferences_u = []
	var integrandDifferences_v = []
	
	# FIRST PASS: unmodified numerical quadrature
	var areas = 0
	while u < SurfaceScriptInstance.uend:
		var v = vintercept
		var u2 = u + uscale
		while v < SurfaceScriptInstance.vend:
			var v2 = v + vscale
			var integrand = calculate_integrand(u, v, u2, v2) if not use_analytical_R_partials else calculate_integrand_using_analytical_R_partials(u, v, uscale, vscale)
			
			#var diff_u_integrand = calculate_integrand_using_analytical_R_partials(u+ufinescale, v, uscale, vscale)
			#var diff_v_integrand = calculate_integrand_using_analytical_R_partials(u, v+vfinescale, uscale, vscale)
			#integrandDifferences_u.append(abs(diff_u_integrand-integrand))
			#integrandDifferences_v.append(abs(diff_v_integrand-integrand))
			
			#if areas % 50000 == 0:
				#print("Diff: ", calculate_analytical_integral(u, u2, v, v2) - integrand)
			
			sum += integrand
			#print(integrand)
			
			v = v2
			areas += 1
		
		u = u2
		
	#for arr in [integrandDifferences_u, integrandDifferences_v]:
		#var sum_indiffs = arr.reduce(func(accum, number): return accum + number, 0)
		#print("Mean integrand differences: ", float(sum_indiffs) / arr.size())
		#print("Max integrand difference: ", arr.max())
	
	return {"sum": sum, "second_sum": sum, "areas": areas, "extra_areas": 0}

func calculate_and_report(use_analytical_R_partials):
	var start_time = Time.get_ticks_usec()
	var results = calculate_full_integral(use_analytical_R_partials)
	var execution_time = Time.get_ticks_usec() - start_time
	print("Flux: ", results["sum"])
	print("Time elapsed: ", execution_time/1000000.0, " s")
	print("Areas: ", results["areas"])
	
	return results["sum"]

func calculate():
	await get_tree().process_frame
	return calculate_and_report(true)
	
func _ready() -> void:
	await get_tree().process_frame
	SurfaceScriptInstance = get_parent().ParametricSurfaceScriptInstance
	FieldScriptInstance = G.WORLD.FieldScriptInstance
