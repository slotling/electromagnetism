extends VectorField

var sphere = preload("res://Junk/sphere.tscn")

func estimate_surface_integral():
	var sum = Vector3.ZERO
	for vert_index in $surface.raw_verts.size():
		var vert = $surface.raw_verts[vert_index]
		var normal = $surface.normals[vert_index]
		var cross = $surface.raw_crosses[vert_index]
		var x = vert.x
		var y = vert.y
		var z = vert.z
		
		var value = F(x, y, z).dot(cross) * Vector3(1, 0, 0)
		sum += value
	return sum

func create_drawing_list() -> void:
	for vert_index in $surface.raw_verts.size():
		var vert = $surface.raw_verts[vert_index]
		var normal = $surface.normals[vert_index]
		var cross = $surface.raw_crosses[vert_index]
		var x = vert.x
		var y = vert.y
		var z = vert.z
		
		var value = F(x, y, z).dot(cross) * normal
		#var value = F(x, y, z)
		
		#print(vert)
		add_drawing_object(x, y, z, value)
	
	print("Flux: ", estimate_surface_integral().x)
		
func get_instance_count():
	return ($surface.i_end+1) * ($surface.j_end+1)
