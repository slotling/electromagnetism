extends Node

var state = {
	"paused": false,
	"sections": []
}

@onready var PL: Dictionary[String, PackedScene] = { # preloads
	"vec": preload("res://Shared/Scenes/display_vector.tscn")
}

@onready var ROOT_WORLD = get_tree().root.get_node("World")
@onready var WORLD = ROOT_WORLD.get_child(0).get_child(0)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
