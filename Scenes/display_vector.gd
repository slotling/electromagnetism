extends Node3D
class_name DisVec

@export var colorScale = 1
@export var colorOffset = 0 # should be same as ends

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	global_position = origpos
	if vec_type == 0:
		look_at(global_position - point)
	
	if not G.WORLD.config.draw.LowDetailMode:
		$AnimationPlayer.play("loop")
		$AnimationPlayer.seek(randf_range(0, 1))

	var transpoint = (point - G.WORLD.calculated_settings["min"]) / (G.WORLD.calculated_settings["max"] - G.WORLD.calculated_settings["min"])
	for i in [$Arrow/Arrow1/Head1, $Point/Point/MeshInstance3D]:
		var material = i.get_active_material(0)
		if material is StandardMaterial3D:
			#print(transpoint)
			if not is_scalar:
				material.albedo_color = Color(transpoint.x, transpoint.y, transpoint.z, material.albedo_color.a)
			elif vec_type != 3:
				material.albedo_color = Color(transpoint.x, transpoint.x, 1 - transpoint.x, material.albedo_color.a)
			

var point: Variant
var origpos:Vector3

var is_scalar: bool
var vec_type

# p: is always a 3d vector in code, but logically only x value used if scalar
# type: 0 - vector, 1 - scalar, 2 - divergence, 3 - curl
func init(p: Vector3, realpos: Vector3, type: int = 0):
	#await get_tree().process_frame
	point = p
	is_scalar = type == 1 or type == 2
	var magnitude = point.length()
	#print(magnitude / G.WORLD.calculated_settings["magmax"] * G.WORLD.config.BaseSize)
	scale = Vector3.ONE * max(G.WORLD.config.draw.MinSize if magnitude != 0 or type == 3 else 0, magnitude / G.WORLD.calculated_settings["magmax"] * G.WORLD.config.draw.BaseSize) * G.WORLD.config.draw.MultSize
	origpos = realpos
	
	vec_type = type
	#print(type)
	
	$Point.visible = false
	$Arrow.visible = false
	$Point/Point.visible = false
	$Point/CurlPoint.visible = false
	
	match type:
		0:
			$Arrow.visible = true
		1:
			$Point/Point.visible = true
			$Point.visible = true
		2:
			$Point/Point.visible = true
			$Point.visible = true
		3:
			$Point/CurlPoint.visible = true
			$Point.visible = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	#print(G.WORLD.maxSize, is_scalar)
	if point == null:
		return
	
	var look = (abs(G.CAMERA.global_transform.basis.z.normalized() * 2) - Vector3.ONE).max(Vector3.ONE * 0) # 0 to avoid visual clutter
	#print(look)
	$Point/CurlPoint/Sprite3D.modulate.a = look.x
	$Point/CurlPoint/Sprite3D2.modulate.a = look.y
	$Point/CurlPoint/Sprite3D3.modulate.a = look.z
	$Point/CurlPoint/MeshInstance3D.transparency = 1 - look.x
	$Point/CurlPoint/MeshInstance3D2.transparency = 1 - look.y
	$Point/CurlPoint/MeshInstance3D3.transparency = 1 - look.z
	var point_rot = -point / G.WORLD.calculated_settings["magmax"] * _delta * 10
	$Point/CurlPoint/MeshInstance3D.rotation.x += point_rot.x
	$Point/CurlPoint/MeshInstance3D2.rotation.y += point_rot.y
	$Point/CurlPoint/MeshInstance3D3.rotation.z += point_rot.z

	#$Node3D.position.z += delta
