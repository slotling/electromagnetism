extends CanvasLayer
class_name FunctionInput

@export var node_path_with_script_instance: NodePath
@export var function_script_instance_to_input = 0
@export var entries = 3
@export var variable_names: Array[String] = []
@export var function_name = "F"
## Refer to Resources/Functions/overrides/SPECIAL_function_input_override.gd
@export_range(0, 4) var overriding_function_id:int = 0 

const OPERATION_SYMBOLS = ["+", "-", "*", "/", ",", "#"] # '#' is a dummy symbol

var FunctionScriptInstances

var string_expressions: PackedStringArray = []

func evaluate(variables, debug=false):
	var results = []
	for string in string_expressions:
		#print(string)
		var expression = Expression.new()
		var finalstring = string
		
		var char_index = 0
		if finalstring.length() != 1:
			while char_index < finalstring.length():
				var substring
				if char_index == 0:
					substring = "#" + finalstring.substr(char_index, 2)
				elif char_index == finalstring.length()-1:
					substring = finalstring.substr(char_index-1, 2) + "#"
				else:
					substring = finalstring.substr(char_index-1, 3)
				if substring[1] in variable_names:
					if not (substring[0] in OPERATION_SYMBOLS or substring[0] == "("):
						finalstring = finalstring.insert(char_index, "*")
						char_index += 1
					if not (substring[2] in OPERATION_SYMBOLS or substring[2] == ")"):
						finalstring = finalstring.insert(char_index+1, "*")
						char_index += 1
					
				char_index += 1
			
			if debug:
				print(finalstring)
		
		for i in variable_names.size():
			finalstring = finalstring.replace(variable_names[i], str(variables[i]))
		#print(finalstring)
		var parse_error = expression.parse(finalstring)
		
		if parse_error != Error.OK:
			return {"error": error_string(parse_error)}
		
		var result = expression.execute()
		#print(result)

		if result == null:
			return {"error": "Unable to parse '" + string + "'"}
		
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
	print(FunctionScriptInstances[function_script_instance_to_input])
	FunctionScriptInstances[function_script_instance_to_input].FUNCTION_PROVIDERS.append(self)
	$Control/SubjectLabel.text = function_name + "(" + ", ".join(variable_names) + ") = "
	var my_array = []
	my_array.resize(entries)
	my_array.fill("+".join(variable_names))
	$Control/LineEdit.placeholder_text = ", ".join(my_array)
	$Control/VecIndicator.visible = entries > 1

var error = ""
var text = ""

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	#$Control/Button.disabled = error != ""

func set_inputs() -> bool:
	text = $Control/LineEdit.text
	var processed_string: String = text.replace(" ", "").replace("^", "**")
	string_expressions = processed_string.split(",")
	#print(string_expressions)
	error = ""
	for string in string_expressions:
		if string == "":
			error = "Empty entry!"
	if entries != string_expressions.size():
		error = "Entry count mismatch! " + str(string_expressions.size()) + " given, " + str(entries) + " required"
	
	if error == "":
		for testCase in [0, 1, 10]:
			var variables_test = []
			variables_test.resize(variable_names.size())
			variables_test.fill(testCase)
			var evaluation = evaluate(variables_test, true)
			#print(evaluation)
			if typeof(evaluation) == TYPE_DICTIONARY and "error" in evaluation:
				error = evaluation["error"]
	
	$Control/Label3.text = '[color="#ff1212"]' + error
	return error == ""
