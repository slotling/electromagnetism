extends Node3D
class_name ChargeDisplay

@export var always_update = false
@export var charge_magnitude:float = 1 # in terms of epsilon_0, the permittivity of free space

var id = null

var hovered = false

var global_position_used_to_calculate = Vector3.ZERO

@onready var parent = get_node("../../ElectricFieldFunctionReplacerController")

func is_selected() -> bool:
	return parent.InspectedCharge == self

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	parent.charge_selected.connect(select_update_event)

var tick = 0

func is_updated() -> bool:
	return $Gizmo.any_pressed()
	
func has_stopped_updating() -> bool:
	return $Gizmo.just_released
	
func E(x, y, z):
	var pos = Vector3(x, y, z)
	var diffpos = pos - get_logical_position()
	var field = diffpos / (diffpos.length()**3) * charge_magnitude / 4 / PI
	return field
	
func get_logical_position() -> Vector3:
	return G.reorient_to_conventional(global_position_used_to_calculate) / G.WORLD.config.draw.PosScale * G.WORLD.config.draw.ValScale

func update_position_for_calculation() -> void:
	global_position_used_to_calculate = global_position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$BaseArea/CollisionShape3D.disabled = not parent.InspectedCharge == null
	if Input.is_action_just_pressed("click"):
		if hovered:
			self_select()
		elif $Gizmo.hovered.x or $Gizmo.hovered.y or $Gizmo.hovered.z:
			pass
		elif is_selected():
			parent.select_update(null)
	
	tick += 1
	if is_selected() and tick % 10 == 0:
		pass
	
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
	parent.select_update(self)
	
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

func _on_base_area_mouse_exited() -> void:
	hovered = false
	hover_event()
