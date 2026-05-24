extends Node3D
class_name DisVec

@export var colorScale = 1
@export var colorOffset = 0 # should be same as ends

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	global_position = origpos
	look_at(global_position - point)
	$AnimationPlayer.play("loop")
	$AnimationPlayer.seek(randf_range(0, 1))

	for i in [$Arrow/Arrow1/Head1, $Point/Point/MeshInstance3D]:
		var material = i.get_active_material(0)
		if material is StandardMaterial3D:
			var transpoint = (point - G.WORLD.calculated_settings["min"]) / (G.WORLD.calculated_settings["max"] - G.WORLD.calculated_settings["min"])
			#print(transpoint)
			if not is_scalar:
				material.albedo_color = Color(transpoint.x, transpoint.y, transpoint.z, material.albedo_color.a)
			else:
				material.albedo_color = Color(transpoint.x, transpoint.x, 1 - transpoint.x, material.albedo_color.a)

var point: Variant
var origpos:Vector3

var is_scalar: bool

# p: is always a 3d vector in code, but logically only x value used if scalar
# type: 0 - vector, 1 - scalar, 2 - divergence, 3 - curl
func init(p: Vector3, realpos: Vector3, type: int = 0):
	#await get_tree().process_frame
	point = p
	is_scalar = type == 1 or type == 2
	var magnitude = point.length()
	scale = Vector3.ONE * max(G.WORLD.config.minSize if magnitude != 0 else 0, magnitude / G.WORLD.calculated_settings["magmax"] * G.WORLD.config.baseSize) * G.WORLD.config.multSize
	$Point.visible = is_scalar
	$Arrow.visible = not is_scalar
	origpos = realpos
	
	match type:
		_:
			pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	#print(G.WORLD.maxSize, is_scalar)
	if point == null:
		return
	#$Node3D.position.z += delta
