extends ChargeDisplay

func function_updater():
	print("hi")
	set_path()

func _ready() -> void:
	#$Path.ParametricCurveScript = ParametricCurveScript
	set_path()
	super()
	
func set_path():
	$Path.generate_points()

# numerical computation of integral:
# int, E(squigglyR) * P(squigglyR) * dS
# = int ustart to uend, E(squigglyR) * P(squigglyR) * (dS/dt) * dt

func E(x, y, z):
	var ParametricCurveScriptInstance = $Path.ParametricCurveScriptInstance
	var pos = Vector3(x, y, z)
	
	var field = Vector3.ZERO
	
	var uscale = ParametricCurveScriptInstance.get_calculation_diff()
	var uintercept = ParametricCurveScriptInstance.get_ustart() # locate at center of patch
	
	var sum = 0
	var u = uintercept
	
	var curPoint = 0
	var curPos = Vector3.ZERO
	var prevPos = Vector3.ZERO
	while u < ParametricCurveScriptInstance.get_uend():
		curPos = ParametricCurveScriptInstance.R(u)
		if curPoint != 0:
			
			var u2 = u + uscale
			
			
			var diffpos = pos - (curPos + get_logical_position())
			field += diffpos / (diffpos.length()**3) * charge_magnitude * (curPos - prevPos).length() * ParametricCurveScriptInstance.P(u)
			
			u = u2
		
		prevPos = curPos
		curPoint += 1
		
	return field
	

#func get_logical_position() -> Vector3:
	#return G.reorient_to_conventional(global_position) / G.WORLD.config.draw.PosScale * G.WORLD.config.draw.ValScale
