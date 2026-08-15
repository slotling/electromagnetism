extends FunctionController

func F(x, y=0, z=0, id=null) -> Vector3:
	return WORLD.get_node("ElectricFieldFunctionReplacerController").F(x, y, z, id)
