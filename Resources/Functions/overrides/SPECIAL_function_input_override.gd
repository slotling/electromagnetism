extends FunctionController

var FUNCTION_PROVIDERS: Array[FunctionInput]
var PARAMETER_PROVIDERS: Array[ParametricRangeInput] # usually only 1 element

func call_provider(variables: Array[float], function_id):
	for provider in FUNCTION_PROVIDERS:
		if provider.overriding_function_id == function_id:
			return provider.evaluate(variables)
	return Vector3.ZERO

func F(x, y=0, z=0, id=null) -> Vector3:
	return call_provider([x, y, z], 0)

func R(u, v=0, w=0) -> Vector3:
	return call_provider([u, v, w], 1)
	
func R_u(u, v=0) -> Vector3:
	return call_provider([u, v], 2)
	
func R_v(u, v) -> Vector3:
	return call_provider([u, v], 3)

func P(u, v=0, w=0) -> float:
	var requested_value = call_provider([u, v, w], 4)
	return 0 if requested_value is Vector3 else requested_value
	
func get_ustart():
	return PARAMETER_PROVIDERS[0].simple_evaluate("ustart") if PARAMETER_PROVIDERS.size() > 0 else ustart
func get_uend():
	return PARAMETER_PROVIDERS[0].simple_evaluate("uend") if PARAMETER_PROVIDERS.size() > 0 else uend
func get_vstart():
	return PARAMETER_PROVIDERS[0].simple_evaluate("vstart") if PARAMETER_PROVIDERS.size() > 0 else vstart
func get_vend():
	return PARAMETER_PROVIDERS[0].simple_evaluate("vend") if PARAMETER_PROVIDERS.size() > 0 else vend
func get_wstart():
	return PARAMETER_PROVIDERS[0].simple_evaluate("wstart") if PARAMETER_PROVIDERS.size() > 0 else wstart
func get_wend():
	return PARAMETER_PROVIDERS[0].simple_evaluate("wend") if PARAMETER_PROVIDERS.size() > 0 else wend
func get_render_diff():
	return PARAMETER_PROVIDERS[0].simple_evaluate("render_diff") if PARAMETER_PROVIDERS.size() > 0 else render_diff
func get_calculation_diff():
	return PARAMETER_PROVIDERS[0].simple_evaluate("calculation_diff") if PARAMETER_PROVIDERS.size() > 0 else calculation_diff
