extends Node3D

var step := 1
var ends_f := Vector3(-5, -5, -5)
var ends_t := Vector3(5, 5, 5)
var posscale := 10
var valscale := 10.0
var baseSize := 2
var multSize := 1
var maxSize := 2
var minSize := 1

var calculated_settings = {
	"max": Vector3.ZERO,
	"magmax": 0,
	"min": Vector3.ZERO,
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(2):
		for ix in range(ends_f.x, ends_t.x+1, step):
			for iy in range(ends_f.y, ends_t.y+1, step):
				for iz in range(ends_f.z, ends_t.z+1, step):
					#if ix**2+iy**2+iz**2 > 30:
						#continue
					
					var x = valscale * ix
					var y = valscale * iy
					var z = valscale * iz
					var value := Vector3(-y+z, -z+x, -x+y)
					# Vector3(x, y, z)
					# Vector3(cos(y), cos(x), 0)
					# Vector3(-y+z, -z+x, -x+y)
					# Vector3((-y+z)**3, (-z+x)**3, (-x+y)**3)
					var pos := Vector3(ix*posscale, iy*posscale, iz*posscale)
					
					if i == 0:
						calculated_settings["max"] = calculated_settings["max"].max(value)
						calculated_settings["magmax"] = max(calculated_settings["magmax"], value.length())
						calculated_settings["min"] = calculated_settings["min"].min(value)
					
					if i == 1:
						var vec: DisVec = G.PL["vec"].instantiate()
						vec.init(value, pos)
						add_child(vec)
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
