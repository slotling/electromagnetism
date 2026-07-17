extends VectorField

var sphere = preload("res://Junk/sphere.tscn")

func create_drawing_list() -> void:
	for vert_index in $surface.raw_verts.size():
		var vert = $surface.raw_verts[vert_index]
		var cross = $surface.raw_crosses[vert_index]
		var normal = cross.normalized()
		var x = vert.x
		var y = vert.y
		var z = vert.z
		
		#var value = F(x, y, z).dot(cross) * normal
		var value = F(x, y, z)
		
		#print(vert)
		add_drawing_object(x, y, z, value)
		
func get_instance_count():
	return ($surface.i_end+1) * ($surface.j_end+1)
