extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var scenes:Dictionary[String, Resource] = {
		"1.1: vector fields": load("res://Worlds/electromagnetism/1_vector_fields/1_1_fields.tscn"),
		"2.1: divergence": load("res://Worlds/electromagnetism/2_derivatives/2_1_divergence.tscn"),
		"test: vector fields": load("res://Worlds/electromagnetism/1_vector_fields/1_1_fields.tscn")
	}
	$SceneSwitcher.init(scenes)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
