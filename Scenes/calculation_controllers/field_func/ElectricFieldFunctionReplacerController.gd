extends Node
class_name ElectricFieldFunctionReplacerController

# attach as child of a VectorField 
# and with the function replaced with the override for elec fields! 
# additionally, add a node3d with the name "Charges"

signal charge_selected(chargeNode)

@export var refresh_config_upon_release = false
@export var recalculate_field_when_dragging = false
@export var recalculate_field_only_on_command = false

@onready var WORLD: VectorField = get_parent()
@onready var charges = WORLD.get_node("Charges").get_children()

@onready var forces = []

var InspectedCharge: ChargeDisplay = null

func function_updater():
	_ready()

func F(x, y=0, z=0, id=null) -> Vector3:
	var sum = Vector3.ZERO
	if id != null:
		for arr in forces:
			sum += arr[id]
	else:
		for charge in charges:
			sum += charge.E(x, y, z)
			
	return sum
	
func add_field(x, y, z, id, extra, charge_id):
	var charge = charges[charge_id]
	var field = charge.E(x, y, z)
	forces[charge_id][id] = field

func update_charge(chargeId, update_drawing_list, refresh_config=false):
	var id = 0
	var drawConfig: DrawConfig = WORLD.config.draw
	charges[chargeId].update_position_for_calculation()
	WORLD.loop_through_all_points(false, Callable(self, "add_field").bind(chargeId))
	
	charge_id_update_list.erase(chargeId)
	
	if update_drawing_list:
		WORLD.create_drawing_list(true) # refresh_config and refresh_config_upon_release

func _ready() -> void:
	for i in charges.size():
		charges[i].id = i
		var arr = []
		print("wic: ", WORLD.get_instance_count())
		arr.resize(WORLD.get_instance_count())
		arr.fill(Vector3.ZERO)
		forces.append(arr)
		update_charge(i, false)
	
func select_update(chargeNode):
	InspectedCharge = chargeNode
	charge_selected.emit(chargeNode)

var charge_id_update_list = []

func _process(delta: float) -> void:
	for i in charges:
		if i.is_updated():
			charge_id_update_list.erase(i.id)
			charge_id_update_list.append(i.id)
			
	if not recalculate_field_only_on_command:
		for i in charges:
			if i.is_updated() and recalculate_field_when_dragging:
				update_charge(i.id, true)
			if i.has_stopped_updating():
				update_charge(i.id, true, true)
