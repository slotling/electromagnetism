extends CalculationController
class_name TestChargeCalculationController

# attach as child of a test charge! (found in any world that extends 5_3_test_charge.tscn)

func calculate():
	var electric_field = Vector3.ZERO
	var pos = get_node("../").get_logical_position()
	for charge in G.WORLD.charges:
		electric_field += charge.E(pos.x, pos.y, pos.z)
	return electric_field
