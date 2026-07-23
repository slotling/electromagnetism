extends VectorField
class_name ChargeVectorField

signal charge_selected(chargeNode)

var InspectedCharge: ChargeDisplay = null

#func _ready() -> void:
	#super()
	
func select_update(chargeNode):
	InspectedCharge = chargeNode
	charge_selected.emit(chargeNode)
