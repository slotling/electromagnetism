extends Node3D

var texture_spacing = 1.0/5.0

@export var ParametricSurfaceScript: Script
@onready var ParametricSurfaceScriptInstance = ParametricSurfaceScript.new() if ParametricSurfaceScript != null else null

# Alias variable name for FunctionInput nodes and consistency
@onready var FunctionScriptInstances = [ParametricSurfaceScriptInstance]
func function_updater():
	generate_surface()

func R(u, v):
	return ParametricSurfaceScriptInstance.R(u, v)
	
@onready var ustart = ParametricSurfaceScriptInstance.ustart
@onready var uend = ParametricSurfaceScriptInstance.uend
@onready var vstart = ParametricSurfaceScriptInstance.vstart
@onready var vend = ParametricSurfaceScriptInstance.vend
@onready var diff = ParametricSurfaceScriptInstance.render_diff

var ireps = 0
var jreps = 0

var raw_verts = PackedVector3Array()
var raw_crosses = PackedVector3Array()
var verts = PackedVector3Array()
var uvs = PackedVector2Array()
var normals = PackedVector3Array()
var indices = PackedInt32Array()

var vector_verts = PackedVector3Array()
var vector_crosses = PackedVector3Array()

var debug_arrays = [null, null]

var i_vector_spacing = 2
var j_vector_spacing = 1

func calc_cross(u, v, u2, v2, currentR):
	return (R(u2, v) - currentR).cross(R(u, v2) - currentR)
	
func reoriented_calc_cross(u, v, u2, v2, currentR):
	return (G.reorient_to_game(R(u2, v) - currentR)).cross(G.reorient_to_game(R(u, v2) - currentR))

func generate_surface():
	var surface_array = []
	surface_array.resize(Mesh.ARRAY_MAX)
	
	raw_verts = PackedVector3Array()
	raw_crosses = PackedVector3Array()
	verts = PackedVector3Array()
	uvs = PackedVector2Array()
	normals = PackedVector3Array()
	indices = PackedInt32Array()
	
	for i in debug_arrays.size():
		debug_arrays[i] = PackedVector3Array()
	
	var uscale = diff
	var vscale = diff
	var uintercept = ustart
	var vintercept = vstart
	ireps = int((uend-ustart)/diff) + 2 # +1 for adding last vertex of floor, +1 for one overshoot to complete surface
	jreps = int((vend-vstart)/diff) + 2
	
	var u = uintercept
	for i in ireps:
		var v = vintercept
		var u2 = u + uscale	
		if i+1 == ireps:
			u = uend
			
		for j in jreps:
			var v2 = v + vscale
			if j+1 == jreps:
				#pass
				v = vend
			
			var raw_vert = R(u, v)
			var vert = raw_vert * G.WORLD.config.draw.PosScale
			vert = G.reorient_to_game(vert)
			var raw_cross = calc_cross(u, v, u2, v2, raw_vert)
			var cross = reoriented_calc_cross(u, v, u2, v2, raw_vert)
			var normal = cross.normalized()
			var uv = Vector2(i * texture_spacing, j * texture_spacing)
			
			debug_arrays[0].push_back(R(u2, v) - raw_vert)
			debug_arrays[1].push_back(R(u, v2) - raw_vert)
			
			raw_verts.push_back(raw_vert)
			raw_crosses.push_back(cross)
			verts.push_back(vert)
			uvs.push_back(uv)
			#print(vert, normal)
			normals.push_back(normal)
			
			var icount = jreps
			if i+1 != ireps and j+1 != jreps and i % i_vector_spacing == 0 and j % j_vector_spacing == 0:
				vector_verts.push_back(raw_vert)
				vector_crosses.push_back(raw_cross)
			
			if i > 0 and j > 0:
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

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	generate_surface()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#_ready()
	#v_intercept -= 0.1
	#print(v_intercept)
	pass
