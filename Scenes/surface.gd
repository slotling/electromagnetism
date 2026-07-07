extends Node3D

var u_start = 0
var u_end = 10
var v_start = 0
var v_end = 9

func F(u, v):
	return Vector3(u, 2*v, u+v)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var vertices = PackedVector3Array()
	for i in range(u_start, u_end, 1):
		var u = i * G.WORLD.config.draw.ValScale
		for j in range(v_start, v_end, 1):
			var v = j * G.WORLD.config.draw.ValScale
			vertices.push_back(F(u, v) * G.WORLD.config.draw.PosScale)

	var arr_mesh = ArrayMesh.new()
	var arrays = []
	arrays.resize(Mesh.ARRAY_MAX)
	arrays[Mesh.ARRAY_VERTEX] = vertices

	# Create the Mesh.
	arr_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
	$MeshInstance3D.mesh = arr_mesh

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
