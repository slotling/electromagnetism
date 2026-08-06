extends CanvasLayer

func _on_button_pressed() -> void:
	$Label.visible = true
	await get_tree().process_frame
	await get_tree().process_frame
	var charge_id_update_list = get_parent().charge_id_update_list
	for i in charge_id_update_list.size():
		get_parent().update_charge(charge_id_update_list[i], i+1 == charge_id_update_list.size())
	$Label.visible = false
