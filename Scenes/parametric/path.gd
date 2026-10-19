extends Node3D

@export var ParametricCurveScript: Script

@onready var ParametricCurveScriptInstance = ParametricCurveScript.new()
@onready var ustart = ParametricCurveScriptInstance.ustart
@onready var uend = ParametricCurveScriptInstance.uend
@onready var diff = ParametricCurveScriptInstance.render_diff

# Alias variable name for FunctionInput nodes and consistency
@onready var FunctionScriptInstances = [ParametricCurveScriptInstance]
func function_updater():
	generate_points()

var raw_points = []

func generate_points():
	raw_points = []
	$Path3D.curve.clear_points()
	
	var uscale = diff
	var uintercept = ustart # locate at center of patch
	
	var sum = 0
	var u = uintercept
	
	while u < uend + uscale:
		#print("path creation: ", u)
		var u2 = u + uscale
		
		if u > uend:
			u = uend
		
		if u == uintercept:
			pass
		
		var raw_pos = ParametricCurveScriptInstance.R(u)
		#print(raw_pos)
		if u != uend:
			raw_points.append(raw_pos)
			
		var pos = G.reorient_to_game(raw_pos) * G.WORLD.config.draw.PosScale / G.WORLD.config.draw.ValScale
		u = u2
		$Path3D.curve.add_point(pos - global_position) 
		# note: quoting the docs -
		# "Adds a point with the specified position relative to the curve's own position, with control points in and out. Appends the new point at the end of the point list." 
		# but the resulting points, when displayed, have had the global position of the path added to it. this is likely a bug.


func _ready() -> void:
	print(ParametricCurveScriptInstance.resource_path)
	generate_points()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
