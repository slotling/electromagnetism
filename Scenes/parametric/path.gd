extends Node3D

@onready var ustart = $FunctionController.ustart
@onready var uend = $FunctionController.uend
@onready var diff = $FunctionController.diff

func _on_ready() -> void:
	var uscale = diff
	var uintercept = ustart # locate at center of patch
	
	var sum = 0
	var u = uintercept
	
	var areas = 0
	while u < uend + uscale:
		var u2 = u + uscale
		
		if u > uend:
			u = uend
			
		var pos = $FunctionController.R(u) * G.WORLD.config.draw.PosScale
		u = u2
		$Path3D.curve.add_point(pos)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
