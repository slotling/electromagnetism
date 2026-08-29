extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var scenes:Dictionary[String, Resource] = {
		"A.1: vector field": load("res://Worlds/1_vector_fields/1_2_custom_functions.tscn"),
		"B.1: parametric curve": load("res://Worlds/3_parametric_equations/3_1_curve.tscn"),
		"B.2: parametric surface": load("res://Worlds/3_parametric_equations/3_2_surface.tscn"),
		"C.1: surface integral": load("res://Worlds/4_integrals/4_2_surface_integral_calculation.tscn"),
		"D.1: electric field": load("res://Worlds/5_electric_charge/5_3_a_test_charge_with_some_charges.tscn"),
		"D.2: line charge distribution": load("res://Worlds/5_electric_charge/5_4_arbitrary_charge_distributions.tscn"),
		"D.3: gauss's law verification": load("res://Worlds/6_gauss_law/6_1_verifying_gauss_law.tscn"),
	}
	var scene_index = scenes.keys().find("D.3: gauss's law verification")
	$SceneSwitcher.init(scenes, scene_index)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
