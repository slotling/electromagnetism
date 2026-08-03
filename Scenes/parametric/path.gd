extends Node3D

@export var ParametricCurveScript: Script

@onready var ParametricCurveScriptInstance = ParametricCurveScript.new()
@onready var ustart = ParametricCurveScriptInstance.ustart
@onready var uend = ParametricCurveScriptInstance.uend
@onready var diff = ParametricCurveScriptInstance.diff

var raw_points = []

func _ready() -> void:
	raw_points = []
	$Path3D.curve.clear_points()
	
	var uscale = diff
	var uintercept = ustart # locate at center of patch
	
	var sum = 0
	var u = uintercept
	
	while u < uend + uscale:
		var u2 = u + uscale
		
		if u > uend:
			u = uend
		
		var raw_pos = ParametricCurveScriptInstance.R(u)
		if u != uend or true:
			raw_points.append(raw_pos)
			
		var pos = G.reorient_to_game(raw_pos) * G.WORLD.config.draw.PosScale / G.WORLD.config.draw.ValScale
		u = u2
		$Path3D.curve.add_point(pos - global_position) 
		# note: quoting the docs -
		# "Adds a point with the specified position relative to the curve's own position, with control points in and out. Appends the new point at the end of the point list." 
		# but the resulting points, when displayed, have had the global position of the path added to it. this is likely a bug.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
