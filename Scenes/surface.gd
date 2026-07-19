extends Node3D


var texture_spacing = 1.0/5.0

#func R(u, v):
	#var pol = PI * u
	#var azi = 2 * PI * v
	#var r = 1
	#return Vector3(sin(pol)*cos(azi), cos(pol), sin(pol)*sin(azi)) * r
	##return Vector3(u, v, u+v) * 10
	##return Vector3(sin(u * 2 * PI / 100), cos(u * 2 * PI / 100), sin(v))
	##return Vector3(v, sin(u) + sin(v), u)
	##return Vector3((2+sin(v)) * cos(u), (2+sin(v)) * sin(u), u + cos(v))
	##return Vector3(2 * cos(u) + v * cos(u/2), 2 * sin(u) + v * cos(u/2), v * sin(u/2))

func R(u, v):
	var x = v * cos(u)
	var y = v * sin(u)
	var result = Vector3(x, y, 1-x*x-y*y)
	return Vector3(result.x, result.z, result.y)
	
var ustart = 0
var uend = 2.0 * PI
var vstart = 0
var vend = 1
var diff = 0.01
	

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

func calc_cross(u, v, u2, v2, currentR):
	return (R(u2, v) - currentR).cross(R(u, v2) - currentR)

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
	
	var uscale = diff
	var vscale = diff
	var uintercept = ustart
	var vintercept = vstart
	var ireps = int((uend-ustart)/diff)
	var jreps = int((vend-vstart)/diff)
	print(ireps, " ", jreps)
	
	var u = uintercept
	for i in ireps:
		var v = vintercept
		var u2 = u + uscale
		for j in jreps:
			print(u, " ", v)
			var v2 = v + vscale
			
			var raw_vert = R(u, v)
			var vert = raw_vert * G.WORLD.config.draw.PosScale
			var cross = calc_cross(u, v, u2, v2, raw_vert)
			var normal = cross.normalized()
			var uv = Vector2(i * texture_spacing, j * texture_spacing)
			
			raw_verts.push_back(raw_vert)
			raw_crosses.push_back(cross)
			verts.push_back(vert)
			uvs.push_back(uv)
			#print(vert, normal)
			normals.push_back(-normal)
			
			if i > 0 and j > 0:
				var icount = jreps
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
				
			v = v2
		u = u2
			
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
