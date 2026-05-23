extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$SceneSwitcher.init({
		"1.1: vector fields": load("res://Worlds/2_electromagnetism/2_1_differential_vector_calculus/2_1_differential_vector_calculus.tscn"),
		"2.1: divergence": load("res://Worlds/2_electromagnetism/2_1_differential_vector_calculus/2_1_divergence.tscn")
	})


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
