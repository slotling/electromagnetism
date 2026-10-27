extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var scenes:Dictionary[String, Resource] = {
		"A.1: vector field": load("res://Worlds/1_vector_fields/1_2_custom_functions.tscn"),
		"A.2: parametric curve": load("res://Worlds/3_parametric_equations/3_3_parametric_curve_input.tscn"),
		"A.3: parametric surface": load("res://Worlds/3_parametric_equations/3_4_custom_parametric_surface.tscn"),
		"B.1: electric field": load("res://Worlds/5_electric_charge/5_3_a_test_charge_with_some_charges.tscn"),
		"B.2: line charges": load("res://Worlds/5_electric_charge/5_4_arbitrary_charge_distributions.tscn"),
		"B.3: gauss's law verification": load("res://Worlds/6_gauss_law/6_1_verifying_gauss_law.tscn"),
	}
	var scene_index = scenes.keys().find("A.1: vector field")
	$SceneSwitcher.init(scenes, scene_index)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
