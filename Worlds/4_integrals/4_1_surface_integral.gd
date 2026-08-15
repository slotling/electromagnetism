extends VectorField

func create_drawing_list_process(initialize) -> void:
	for vert_index in $surface.vector_verts.size():
		var vert = $surface.vector_verts[vert_index]
		var cross = $surface.vector_crosses[vert_index]
		var normal = cross.normalized()
		var x = vert.x
		var y = vert.y
		var z = vert.z
		
		var value = F(x, y, z).dot(cross) * normal
		#print(F(x, y, z), cross, normal, value)
		#var value = F(x, y, z)
		#var value = cross
		
		#print(vert)
		#add_drawing_object(x, y, z, $surface.debug_arrays[0][vert_index], initialize)
		#add_drawing_object(x, y, z, $surface.debug_arrays[1][vert_index], initialize)
		#add_drawing_object(x, y, z, normal, initialize)
		add_drawing_object(x, y, z, value, initialize)
		
func get_instance_count():
	return $surface.vector_verts.size() # remove overshooting vertices
