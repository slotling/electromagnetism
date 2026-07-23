extends Node3D

var hovered = {
	"x": false,
	"y": false,
	"z": false
}

var pressed = {
	"x": false,
	"y": false,
	"z": false
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	
var mouse_movement: Vector2
var debug_mouse_movement: Vector2
func _input(event):
	if event is InputEventMouseMotion:
		mouse_movement = event.relative
		debug_mouse_movement = event.relative

var old_global_position: Vector3

func any_pressed() -> bool:
	return pressed["x"] or pressed["y"] or pressed["z"]

var tick = 0
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	for i in $Arrows.get_child_count():
		var arrow = $Arrows.get_child(i)
		arrow.get_node("Mesh/Area/CollisionShape3D").disabled = not get_parent().is_selected()

	if any_pressed():
		tick = 0
	tick += 1
	if get_parent().is_selected():
		if Input.is_action_just_pressed("click"):
			pressed = hovered.duplicate()
			old_global_position = global_position
		if Input.is_action_just_released("click"):
			for i in pressed.keys():
				pressed[i] = false
			
		var relpos = G.CAMERA.global_position - old_global_position # relative position
		relpos = G.reorient_to_conventional(relpos)
		var deadzone = 5e-5 
		if abs(relpos.x) < deadzone:
			relpos.x = 0
		if abs(relpos.y) < deadzone:
			relpos.y = 0
		if abs(relpos.z) < deadzone:
			relpos.z = 0
		var pol = acos(relpos.z/relpos.length())
		var azi = atan2(relpos.y, relpos.x) + PI/2.0
		
		if relpos.x == 0 and relpos.y == 0:
			azi = G.CAMERA.pivot.rotation.y * (-1 if pol == 0 else 1)
		
		# screen components
		var x_axis_components = Vector2(cos(azi), sin(azi) * cos(pol)).normalized()
		var y_axis_components = Vector2(cos(azi - PI/2), sin(azi - PI/2) * cos(pol)).normalized()
		var z_axis_components = Vector2(0, 1).normalized()
		
		#if tick % 10 == 1 and any_pressed():
			#print()
			##print("relative pos: ", relpos.y, " ", relpos.x)
			#print("Polar angle: ", rad_to_deg(pol))
			#print("Azimuthal angle: ", rad_to_deg(azi))
			#print("XAC:", x_axis_components)
			#print("YAC:", y_axis_components)
			#print("MM:", debug_mouse_movement)
			#print("MMXAC:", debug_mouse_movement.dot(x_axis_components))
			#print("MMYAC:", debug_mouse_movement.dot(y_axis_components))
		
		var speed = 0.25
		get_parent().global_position.x += mouse_movement.dot(x_axis_components) * (1 if pressed["x"] else 0) * speed
		get_parent().global_position.z -= mouse_movement.dot(y_axis_components) * (1 if pressed["y"] else 0) * speed
		get_parent().global_position.y -= mouse_movement.dot(z_axis_components) * (1 if pressed["z"] else 0) * speed
		
		mouse_movement = Vector2.ZERO

func tween_scale(node, size):
	var tween = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	tween.tween_property(node, "scale", Vector3.ONE*[1.0, 1.0, 1.5][size], 0.05)

func _on_area_x_mouse_entered() -> void:
	hovered["x"] = true
	tween_scale($Arrows/x, 2)
	tween_scale($Arrows/y, 0)
	tween_scale($Arrows/z, 0)

func _on_area_x_mouse_exited() -> void:
	hovered["x"] = false
	tween_scale($Arrows/x, 1)
	tween_scale($Arrows/y, 1)
	tween_scale($Arrows/z, 1)

func _on_area_y_mouse_entered() -> void:
	hovered["y"] = true
	tween_scale($Arrows/x, 0)
	tween_scale($Arrows/y, 2)
	tween_scale($Arrows/z, 0)

func _on_area_y_mouse_exited() -> void:
	hovered["y"] = false
	tween_scale($Arrows/x, 1)
	tween_scale($Arrows/y, 1)
	tween_scale($Arrows/z, 1)

func _on_area_z_mouse_entered() -> void:
	hovered["z"] = true
	tween_scale($Arrows/x, 0)
	tween_scale($Arrows/y, 0)
	tween_scale($Arrows/z, 2)

func _on_area_z_mouse_exited() -> void:
	hovered["z"] = false
	tween_scale($Arrows/x, 1)
	tween_scale($Arrows/y, 1)
	tween_scale($Arrows/z, 1)
