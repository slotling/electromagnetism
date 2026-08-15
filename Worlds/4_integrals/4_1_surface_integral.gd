extends VectorField

@export var drawNormals = true

func loop_through_all_points(initialize: bool, callable: Callable):
	var id = 0
	for vert_index in $surface.vector_verts.size():
		var vert = $surface.vector_verts[vert_index]
		var cross = $surface.vector_crosses[vert_index]
		var normal = cross.normalized()
		var x = vert.x
		var y = vert.y
		var z = vert.z
		callable.call(x, y, z, id, {"cross": cross, "normal": normal, "initialize": initialize})
		id += 1

func every_point(x, y, z, id, extra):
	var value = F(x, y, z, id)
	if drawNormals:
		value = value.dot(extra["cross"]) * extra["normal"]
	add_drawing_object(x, y, z, value, extra["initialize"])
		
func get_instance_count():
	return $surface.vector_verts.size() # remove overshooting vertices
