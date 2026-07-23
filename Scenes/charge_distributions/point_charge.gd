extends Node3D
class_name ChargeDisplay

var hovered = false

func is_selected() -> bool:
	return get_parent().InspectedCharge == self

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_parent().charge_selected.connect(select_update_event)


var tick = 0
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$BaseArea/CollisionShape3D.disabled = not get_parent().InspectedCharge == null
	if Input.is_action_just_pressed("click"):
		if hovered:
			self_select()
		elif $Gizmo.hovered.x or $Gizmo.hovered.y or $Gizmo.hovered.z:
			pass
		elif is_selected():
			get_parent().select_update(null)
	
	tick += 1
	if is_selected() and tick % 10 == 0:
		pass
		#var relpos = G.CAMERA.global_position - global_position # relative position
		#relpos = G.reorient(relpos)
		#var deadzone = 5e-5 
		#if abs(relpos.x) < deadzone:
			#relpos.x = 0
		#if abs(relpos.y) < deadzone:
			#relpos.y = 0
		#if abs(relpos.z) < deadzone:
			#relpos.z = 0
		#var pol = acos(relpos.z/relpos.length())
		#var azi = atan2(relpos.y, relpos.x) + PI/2.0
		#
		#if relpos.x == 0 and relpos.y == 0:
			#azi = G.CAMERA.pivot.rotation.y * (1 if pol == 0 else -1)
		#
		#var x_axis_components = Vector2(cos(azi), - sin(azi) * cos(pol))
		#var y_axis_components = Vector2(cos(azi - PI/2), - sin(azi - PI/2) * cos(pol))
		#var z_axis_components = Vector2(0, 1)
		#
		#print()
		##print("relative pos: ", relpos.y, " ", relpos.x)
		##print("Polar angle: ", rad_to_deg(pol))
		##print("Azimuthal angle: ", rad_to_deg(azi))
		#print("XAC:", x_axis_components)
		#print("YAC:", y_axis_components)
	
func hover_event():
	if not is_selected():
		#$MeshInstance3D.get_active_material(0).emission_enabled = hovered
		$MeshInstance3D.get_active_material(0).albedo_color = Color("yellow" if hovered else "white")

func select_update_event(chargeNode):
	if chargeNode == self:
		select_event()
	else:
		deselect_event()

func self_select():
	get_parent().select_update(self)
	
func select_event():
	#$MeshInstance3D.get_active_material(0).emission_enabled = true
	$MeshInstance3D.get_active_material(0).albedo_color = Color("cyan")
	$Gizmo.visible = true
	
func deselect_event():
	hover_event()
	$Gizmo.visible = false

func _on_base_area_mouse_entered() -> void:
	hovered = true
	hover_event()
	#print("in")

func _on_base_area_mouse_exited() -> void:
	hovered = false
	hover_event()
	#print("out")
