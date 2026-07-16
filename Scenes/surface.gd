extends Node3D

var i_start = 0
var i_end = 500
var j_start = 0
var j_end = 500

func F(u, v):
	var pol = PI * u / 100
	var azi = 2 * PI * v / 100
	var r = 50
	#return Vector3(r*sin(pol)*cos(azi), r*cos(pol), r*sin(pol)*sin(azi))
	#return Vector3(u, v, u+v) * 10
	#return Vector3(sin(u * 2 * PI / 100), cos(u * 2 * PI / 100), sin(v)) * 10
	return Vector3(u-50, sin(u) + sin(v), v-50)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var surface_array = []
	surface_array.resize(Mesh.ARRAY_MAX)
	
	var verts = PackedVector3Array()
	var uvs = PackedVector2Array()
	var normals = PackedVector3Array()
	var indices = PackedInt32Array()
	
	#for i in range(u_start, u_end, 1):
		#for j in range(v_start, v_end, 1):
			#var u = i * G.WORLD.config.draw.ValScale
			#var u2 = (i+1) * G.WORLD.config.draw.ValScale
			#var v = j * G.WORLD.config.draw.ValScale
			#var v2 = (j+1) * G.WORLD.config.draw.ValScale
			#verts.push_back(F(u, v) * G.WORLD.config.draw.PosScale)
			#uvs.push_back(Vector2(u, v))
			#normals.push_back((F(u2, v) - F(u, v)).cross(F(u, v2) - F(u, v)).normalized())
	
	for i in range(i_start, i_end+1):
		for j in range(j_start, j_end+1):
			var u = i * G.WORLD.config.draw.ValScale
			var u2 = (i+1) * G.WORLD.config.draw.ValScale
			var v = j * G.WORLD.config.draw.ValScale
			var v2 = (j+1) * G.WORLD.config.draw.ValScale
			
			var vert = F(u, v) * G.WORLD.config.draw.PosScale
			var normal = F(u, v).normalized()
			var uv = Vector2(i/10.0, j/10.0)
			verts.push_back(vert)
			uvs.push_back(uv)
			normals.push_back(-(F(u2, v) - F(u, v)).cross(F(u, v2) - F(u, v)).normalized())
			
			if i > 0 and v > 0:
				var icount = i_end - i_start + 1
				indices.push_back(i*icount + j-1)
				indices.push_back((i-1)*icount + j)
				indices.push_back((i-1)*icount + j-1)
				
				indices.push_back(i*icount + j-1)
				indices.push_back(i*icount + j)
				indices.push_back((i-1)*icount + j)
				
				indices.push_back((i-1)*icount + j-1)
				indices.push_back((i-1)*icount + j)
				indices.push_back(i*icount + j-1)
				
				indices.push_back((i-1)*icount + j)
				indices.push_back(i*icount + j)
				indices.push_back(i*icount + j-1)
			
	surface_array[Mesh.ARRAY_VERTEX] = verts
	surface_array[Mesh.ARRAY_TEX_UV] = uvs
	surface_array[Mesh.ARRAY_NORMAL] = normals
	surface_array[Mesh.ARRAY_INDEX] = indices
	

	$MeshInstance3D.mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, surface_array)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
