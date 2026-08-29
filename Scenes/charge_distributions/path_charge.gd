extends ChargeDisplay

@export var ParametricCurveScript: Script
@onready var ParametricCurveScriptInstance = ParametricCurveScript.new()

# Alias variable name for FunctionInput nodes and consistency
@onready var FunctionScriptInstances = [ParametricCurveScriptInstance]

func _ready() -> void:
	super()
	$Path.ParametricCurveScript = ParametricCurveScript
	$Path._ready()

# numerical computation of integral:
# int, E(squigglyR) * P(squigglyR) * dS
# = int ustart to uend, E(squigglyR) * P(squigglyR) * (dS/dt) * dt

func E(x, y, z):
	var pos = Vector3(x, y, z)
	
	var field = Vector3.ZERO
	
	var uscale = ParametricCurveScriptInstance.calculation_diff
	var uintercept = ParametricCurveScriptInstance.ustart # locate at center of patch
	
	var sum = 0
	var u = uintercept
	
	var curPoint = 0
	while u < ParametricCurveScriptInstance.uend:
		var u2 = u + uscale
		
		var curPos = $Path.raw_points[curPoint]
		var diffpos = pos - (curPos + get_logical_position())
		field += diffpos / (diffpos.length()**3) * charge_magnitude * ($Path.raw_points[curPoint] - $Path.raw_points[curPoint + 1]).length() * ParametricCurveScriptInstance.P(u)
		
		u = u2
		curPoint += 1
		
	return field
	

#func get_logical_position() -> Vector3:
	#return G.reorient_to_conventional(global_position) / G.WORLD.config.draw.PosScale * G.WORLD.config.draw.ValScale
