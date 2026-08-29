extends CanvasLayer

@export var node_paths_with_script_instance: Array[NodePath]
@export var node_paths_of_function_inputs: Array[NodePath]

func _on_button_pressed() -> void:
	var error_inputs = false
	for i in node_paths_of_function_inputs:
		#print(get_node(i)._on_button_pressed())
		error_inputs = error_inputs or not get_node(i)._on_button_pressed()
	if error_inputs:
		return
	for i in node_paths_with_script_instance:
		get_node(i).function_updater()
