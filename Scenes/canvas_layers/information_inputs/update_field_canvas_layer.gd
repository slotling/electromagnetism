extends CanvasLayer

@onready var parent: ElectricFieldFunctionReplacerController = get_node("../ElectricFieldFunctionReplacerController")
@export var ButtonsToBePressed: Array[NodePath]
func _on_button_pressed() -> void:
	$Label.visible = true
	await get_tree().process_frame
	await get_tree().process_frame
	for i in ButtonsToBePressed:
		get_node(i).pressed.emit()
	var charge_id_update_list = parent.charge_id_update_list
	for i in charge_id_update_list.size():
		parent.update_charge(charge_id_update_list[i], i+1 == charge_id_update_list.size())
	$Label.visible = false
