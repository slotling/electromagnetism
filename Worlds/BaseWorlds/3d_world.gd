extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var scenes:Dictionary[String, Resource] = {
		"1.1: vector field": load("res://Worlds/1_vector_fields/1_1_fields.tscn"),
		"2.1: divergence": load("res://Worlds/2_derivatives/2_1_divergence.tscn"),
		"2.2: curl": load("res://Worlds/2_derivatives/2_2_curl.tscn"),
		"2.3: gradient": load("res://Worlds/2_derivatives/2_3_gradient.tscn"),
		"3.1: parametric curve": load("res://Worlds/3_parametric_equations/3_1_curve.tscn"),
		"3.2: parametric surface": load("res://Worlds/3_parametric_equations/3_2_surface.tscn"),
		"4.1: surface integral": load("res://Worlds/4_integrals/4_1_surface_integral.tscn"),
		#"5.1: electric charge": load("res://Worlds/5_electric_charge/5_1_electric_charge.tscn"),
		"5.2: electric field": load("res://Worlds/5_electric_charge/5_2_electric_field.tscn"),
	}
	$SceneSwitcher.init(scenes, 7)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
