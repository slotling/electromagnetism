extends VectorField
class_name ChargeVectorField
#
#signal charge_selected(chargeNode)

#@export var refresh_config_upon_release = false
#@export var recalculate_field_when_dragging = false
#@export var recalculate_field_only_on_command = false
#
#@onready var charges = $Charges.get_children()
#
#var forces = []
#
#var InspectedCharge: ChargeDisplay = null
#
#func F(x, y=0, z=0, id=null) -> Vector3:
	#var sum = Vector3.ZERO
	#for arr in forces:
		#sum += arr[id]
	#return sum
#
#func update_charge(charge_id, update_drawing_list, refresh_config=false):
	#var id = 0
	#var charge = charges[charge_id]
	#for ix in range(config.draw.LatticeStart.x, config.draw.LatticeEnd.x+1, 1):
		#for iy in range(config.draw.LatticeStart.y, config.draw.LatticeEnd.y+1, 1):
			#for iz in range(config.draw.LatticeStart.z, config.draw.LatticeEnd.z+1, 1):
				#var x = config.draw.ValScale * ix
				#var y = config.draw.ValScale * iy
				#var z = config.draw.ValScale * iz
				#var field = charge.E(x, y, z)
				#forces[charge_id][id] = field
				#id += 1
				#
	#charge_id_update_list.erase(charge_id)
	#
	#if update_drawing_list:
		#create_drawing_list(true) # refresh_config and refresh_config_upon_release
#
#func _ready() -> void:
	#for i in charges.size():
		#charges[i].id = i
		#var arr = []
		#arr.resize(get_instance_count())
		#arr.fill(Vector3.ZERO)
		#forces.append(arr)
		#update_charge(i, false)
	#super()
	#
#func select_update(chargeNode):
	#InspectedCharge = chargeNode
	#charge_selected.emit(chargeNode)
#
#var charge_id_update_list = []
#
#func _process(delta: float) -> void:
	#super(delta)
	#for i in charges:
		#if i.is_updated():
			#charge_id_update_list.erase(i.id)
			#charge_id_update_list.append(i.id)
			#
	#if not recalculate_field_only_on_command:
		#for i in charges:
			#if i.is_updated() and recalculate_field_when_dragging:
				#update_charge(i.id, true)
			#if i.has_stopped_updating():
				#update_charge(i.id, true, true)
