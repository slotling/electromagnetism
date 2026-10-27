extends CalculationController
class_name SurfaceIntegralCalculationController

# attach as child of parametric surface

@onready var SurfaceScriptInstance: FunctionController
@onready var FieldScriptInstance: FunctionController

@export var use_analytical_R_partials = true

var normal_cache = {} # u, v hierarchy

func R(u, v):
	return SurfaceScriptInstance.R(u, v)
	
func R_partial(u, v, partial="u"):
	var partial_func_callable: Callable = SurfaceScriptInstance.R_u if partial=="u" else SurfaceScriptInstance.R_v
	return partial_func_callable.call(u, v)

func F(x, y, z):
	return FieldScriptInstance.F(x, y, z)

# efficient one given you worked out the derivatives
func calculate_integrand_using_analytical_R_partials(u, v, uscale, vscale, use_cache=true, store_cache=true):
	var currentR = R(u, v)
	
	var diffCross
	if not u in normal_cache and store_cache:
		normal_cache[u] = {}
	if not v in normal_cache[u] or not use_cache:
		diffCross = R_partial(u, v, "u").cross(R_partial(u, v, "v")) * uscale * vscale
		if store_cache:
			normal_cache[u][v] = diffCross
	else:
		diffCross = normal_cache[u][v]
	
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

func calculate_full_integral():
	var uscale = SurfaceScriptInstance.get_calculation_diff()
	var vscale = SurfaceScriptInstance.get_calculation_diff()
	var uintercept = SurfaceScriptInstance.get_ustart() + SurfaceScriptInstance.get_calculation_diff()/2 # locate at center of patch
	var vintercept = SurfaceScriptInstance.get_vstart() + SurfaceScriptInstance.get_calculation_diff()/2 # locate at center of patch
	
	var sum = 0
	var u = uintercept
	
	var integrandDifferences_u = []
	var integrandDifferences_v = []
	
	# FIRST PASS: unmodified numerical quadrature
	var areas = 0
	while u < SurfaceScriptInstance.get_uend():
		var v = vintercept
		var u2 = u + uscale
		while v < SurfaceScriptInstance.get_vend():
			var v2 = v + vscale
			var integrand = calculate_integrand(u, v, u2, v2) if not use_analytical_R_partials else calculate_integrand_using_analytical_R_partials(u, v, uscale, vscale)
			
			sum += integrand
			
			v = v2
			areas += 1
		
		u = u2
	
	return {"sum": sum, "areas": areas}

func calculate_and_report():
	var start_time = Time.get_ticks_usec()
	var results = calculate_full_integral()
	var execution_time = Time.get_ticks_usec() - start_time
	print("Flux: ", results["sum"])
	print("Time elapsed: ", execution_time/1000000.0, " s")
	print("Areas: ", results["areas"])
	
	return results["sum"]

func calculate():
	await get_tree().process_frame
	return calculate_and_report()
	
func _ready() -> void:
	await get_tree().process_frame
	SurfaceScriptInstance = get_parent().ParametricSurfaceScriptInstance
	FieldScriptInstance = G.WORLD.FieldScriptInstance
