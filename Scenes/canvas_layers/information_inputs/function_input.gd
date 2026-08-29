extends CanvasLayer

@export var node_path_with_script_instance: NodePath
@export var function_script_instance_to_input = 0
@export var entries = 3
@export var variable_names: Array[String] = []
@export var function_name = "F"

var FunctionScriptInstances

var string_expressions: PackedStringArray = []

func evaluate(variables: Array[float]):
	var results = []
	for string in string_expressions:
		var expression = Expression.new()
		var finalstring = string
		for i in variable_names.size():
			finalstring = finalstring.replace(variable_names[i], str(variables[i]))
		expression.parse(finalstring)
		var result = expression.execute()
		results.push_back(result)
	
	if entries == 1:
		return results[0]
	elif entries == 2:
		return Vector3(results[0], results[1], 0)
	elif entries == 3:
		return Vector3(results[0], results[1], results[2])
	else:
		return results

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().process_frame
	await get_tree().process_frame
	FunctionScriptInstances = get_node(node_path_with_script_instance).FunctionScriptInstances
	FunctionScriptInstances[function_script_instance_to_input].FUNCTION_PROVIDER = self
	$Control/SubjectLabel.text = function_name + "(" + ", ".join(variable_names) + ") = "
	$Control/VecIndicator.visible = entries > 1

var error = ""
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	return
	var processed_string: String = $Control/LineEdit.text.replace(" ", "")
	string_expressions = processed_string.split(",")
	#print(string_expressions)
	error = ""
	for string in string_expressions:
		if string == "":
			error = "Empty entry!"
	if entries != string_expressions.size():
		error = "Entry count mismatch!"
	
	$Control/Label3.text = '[color="#ff1212"]' + error
	
	$Control/Button.disabled = error != ""
