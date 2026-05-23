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

	var material = $Node3D/MeshInstance3D.get_active_material(0)
	if material is StandardMaterial3D:
		var transpoint = (point - G.WORLD.calculated_settings["min"]) / (G.WORLD.calculated_settings["max"] - G.WORLD.calculated_settings["min"])
		material.albedo_color = Color(transpoint.x, transpoint.y, transpoint.z, material.albedo_color.a)
		#material.albedo_color = Color(randf_range(0, 1), randf_range(0, 1), randf_range(0, 1))

var point:Vector3
var origpos:Vector3

func init(p: Vector3, realpos: Vector3):
	point = p
	#scale = Vector3.ONE * min(maxSize, baseSize * point.length())
	scale = Vector3.ONE * max(G.WORLD.minSize if point.length() != 0 else 0, point.length() / G.WORLD.calculated_settings["magmax"] * G.WORLD.baseSize) * G.WORLD.multSize

	origpos = realpos

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if point == null:
		return
	#$Node3D.position.z += delta
