extends Node3D

var i_end = 25
var j_end = 25
var texture_spacing = 1.0/5.0
var u_scale = 1/float(i_end)
var v_scale = 1/float(j_end)
var u_intercept = 0
var v_intercept = 0

func F(u, v):
	var pol = PI * u
	var azi = 2 * PI * v
	var r = 1
	return Vector3(sin(pol)*cos(azi), cos(pol), sin(pol)*sin(azi)) * r
	#return Vector3(u, v, u+v) * 10
	#return Vector3(sin(u * 2 * PI / 100), cos(u * 2 * PI / 100), sin(v))
	#return Vector3(v, sin(u) + sin(v), u)
	#return Vector3((2+sin(v)) * cos(u), (2+sin(v)) * sin(u), u + cos(v))
	#return Vector3(2 * cos(u) + v * cos(u/2), 2 * sin(u) + v * cos(u/2), v * sin(u/2))

var calc_raw_verts = PackedVector3Array()
var calc_raw_crosses = PackedVector3Array()

func calculate_raw_values():
	pass

var raw_verts = PackedVector3Array()
var raw_crosses = PackedVector3Array()
var verts = PackedVector3Array()
var uvs = PackedVector2Array()
var normals = PackedVector3Array()
var indices = PackedInt32Array()

func calc_cross(u, v, u2, v2):
	return -(F(u2, v) - F(u, v)).cross(F(u, v2) - F(u, v))

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var surface_array = []
	surface_array.resize(Mesh.ARRAY_MAX)
	
	raw_verts = PackedVector3Array()
	raw_crosses = PackedVector3Array()
	verts = PackedVector3Array()
	uvs = PackedVector2Array()
	normals = PackedVector3Array()
	indices = PackedInt32Array()
	
	#for i in range(u_start, u_end, 1):
		#for j in range(v_start, v_end, 1):
			#var u = i * G.WORLD.config.draw.ValScale
			#var u2 = (i+1) * G.WORLD.config.draw.ValScale
			#var v = j * G.WORLD.config.draw.ValScale
			#var v2 = (j+1) * G.WORLD.config.draw.ValScale
			#verts.push_back(F(u, v) * G.WORLD.config.draw.PosScale)
			#uvs.push_back(Vector2(u, v))
			#normals.push_back((F(u2, v) - F(u, v)).cross(F(u, v2) - F(u, v)).normalized())
	
	for i in range(0, i_end+1):
		for j in range(0, j_end+1):
			var u = i * u_scale + u_intercept
			var u2 = (i+1) * u_scale + u_intercept
			var v = j * v_scale + v_intercept
			var v2 = (j+1) * v_scale + v_intercept
			#print(u, " ", v)
			
			var raw_vert = F(u, v)
			var vert = raw_vert * G.WORLD.config.draw.PosScale
			var cross = calc_cross(u, v, u2, v2)
			var normal = cross.normalized()
			var uv = Vector2(i * texture_spacing, j * texture_spacing)
			
			raw_verts.push_back(raw_vert)
			raw_crosses.push_back(cross)
			verts.push_back(vert)
			uvs.push_back(uv)
			#print(vert, normal)
			normals.push_back(-normal)
			
			if i > 0 and j > 0:
				var icount = j_end + 1
				# front triangles
				indices.push_back(i*icount + j-1)
				indices.push_back((i-1)*icount + j)
				indices.push_back((i-1)*icount + j-1)
				
				indices.push_back(i*icount + j-1)
				indices.push_back(i*icount + j)
				indices.push_back((i-1)*icount + j)
				
				# back triangles
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
	
	$MeshInstance3D.mesh.clear_surfaces()
	$MeshInstance3D.mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, surface_array)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#_ready()
	#v_intercept -= 0.1
	#print(v_intercept)
	pass
