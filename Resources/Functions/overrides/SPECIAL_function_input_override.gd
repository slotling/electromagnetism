extends FunctionController

var FUNCTION_PROVIDERS: Array[FunctionInput]

func call_provider(variables: Array[float], function_id):
	for provider in FUNCTION_PROVIDERS:
		if provider.overriding_function_id == function_id:
			return provider.evaluate(variables)
	#print("No provider provides this function.")
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
	return call_provider([u, v, w], 4)
