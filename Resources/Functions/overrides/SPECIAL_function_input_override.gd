extends FunctionController

var FUNCTION_PROVIDER = null

func F(x, y=0, z=0, id=null) -> Vector3:
	return FUNCTION_PROVIDER.evaluate([x, y, z]) if FUNCTION_PROVIDER else Vector3.ZERO

func R(u, v=0, w=0) -> Vector3:
	return FUNCTION_PROVIDER.evaluate([u, v, w]) if FUNCTION_PROVIDER else Vector3.ZERO
	
func R_u(u, v=0) -> Vector3:
	return FUNCTION_PROVIDER.evaluate([u, v]) if FUNCTION_PROVIDER else Vector3.ZERO
	
func R_v(u, v) -> Vector3:
	return FUNCTION_PROVIDER.evaluate([u, v]) if FUNCTION_PROVIDER else Vector3.ZERO

func P(u, v=0, w=0) -> float:
	return FUNCTION_PROVIDER.evaluate([u, v, w]) if FUNCTION_PROVIDER else 0
