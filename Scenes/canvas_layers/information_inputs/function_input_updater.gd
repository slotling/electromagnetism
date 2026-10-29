extends CanvasLayer

## NODE PATHS TO UPDATE
@export var node_paths_with_script_instance: Array[NodePath]
@export var node_paths_of_function_inputs: Array[NodePath]

func _ready() -> void:
	await get_tree().process_frame
	await get_tree().process_frame
	_on_button_pressed()

func _on_button_pressed() -> void:
	if visible:
		$Label.visible = true
		await get_tree().process_frame
		await get_tree().process_frame
	
	var error_inputs = false
	for i in node_paths_of_function_inputs:
		error_inputs = error_inputs or not get_node(i).set_inputs()
	if error_inputs:
		return
	for i in node_paths_with_script_instance:
		get_node(i).function_updater()
	
	$Label.visible = false
