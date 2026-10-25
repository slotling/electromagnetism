extends CanvasLayer
class_name ParametricRangeInput

@export var node_path_with_script_instance: NodePath
@export var function_script_instance_to_input = 0

var FunctionScriptInstances

var string_expressions: PackedStringArray = []
var string_expressions_identifier = ["ustart", "uend", "vstart", "vend", "render_diff", "calculation_diff", "wstart", "wend"]

func simple_evaluate(parameter_requested, debug=false) -> Variant:
	var string_expression_index = string_expressions_identifier.find(parameter_requested)

	var expression = Expression.new()
	var string = string_expressions[string_expression_index]
	var finalstring = string
	var parse_error = expression.parse(finalstring)
	
	if parse_error != Error.OK:
		return {"error": error_string(parse_error)}
	
	var result = expression.execute()

	if result == null:
		return {"error": "Unable to parse '" + string + "'"}
	
	return result

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().process_frame
	await get_tree().process_frame
	FunctionScriptInstances = get_node(node_path_with_script_instance).FunctionScriptInstances
	print(FunctionScriptInstances[function_script_instance_to_input])
	FunctionScriptInstances[function_script_instance_to_input].PARAMETER_PROVIDERS.append(self)

var error = ""
var text = ""

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	#$Control/Button.disabled = error != ""

func set_inputs() -> bool:
	var errored = false
	string_expressions = []
	
	var current_string_expression_index = 0
	for i in $Control.get_child_count():
		var control_child: ParameterSubinput = $Control.get_child(i)
		var entries = 2 if control_child.is_an_interval else 1
		if control_child.is_disabled:
			current_string_expression_index += entries
			continue
		
		var processed_string: String
		var current_string_expressions: PackedStringArray
		if control_child.is_an_interval:
			text = control_child.get_node("LineEdit").text
			processed_string = text.replace(" ", "").replace("^", "**").lstrip("[").rstrip("]")
			current_string_expressions = processed_string.split(",")
		else:
			text = control_child.get_node("LineEdit").text
			processed_string = text.replace(" ", "").replace("^", "**")
			current_string_expressions = [processed_string]

		error = ""
		for string in current_string_expressions:
			if string == "":
				error = "Empty entry!"
		if entries != current_string_expressions.size():
			error = "Entry count mismatch! " + str(current_string_expressions.size()) + " given, " + str(entries) + " required"
		
		string_expressions = string_expressions + current_string_expressions
		
		if error == "":
			for j in current_string_expressions.size():
				var evaluation = simple_evaluate(string_expressions_identifier[current_string_expression_index], true)
				if typeof(evaluation) == TYPE_DICTIONARY and "error" in evaluation:
					error = evaluation["error"]
				current_string_expression_index += 1
		
		control_child.get_node("Label3").text = '[color="#ff1212"]' + error
		
		errored = error == "" or errored
	return errored
