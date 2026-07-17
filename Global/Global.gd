extends Node

var current_function_index = "2dswirl"
var FUNCTIONS: Dictionary[String, Array] = { # Dictionary[String, Array[Callable]]
	"default": [
		func(x, y, z): return Vector3(x, y, z), 
		func(x, y, z): return Vector3(0, 0, 0),
		func(x, y, z): return 3, 
		func(x, y, z): return Vector3(0, 0, 0)
	],
	"sine": [
		func(x, y, z): return Vector3(sin(x), sin(y), sin(z)), 
		func(x, y, z): return Vector3(0, 0, 0),
		func(x, y, z): return 0, 
		func(x, y, z): return Vector3(0, 0, 0)
	],
	"2dswirl": [
		func(x, y, z): return Vector3(sin(y), sin(x), 0), 
		func(x, y, z): return Vector3(0, 0, 0),
		func(x, y, z): return 0, 
		func(x, y, z): return Vector3(0, 0, -sin(x) + sin(y))
	],
	"rotary": [
		func(x, y, z): return Vector3(-y+z, -z+x, -x+y), 
		func(x, y, z): return Vector3(0, 0, 0),
		func(x, y, z): return 0, 
		func(x, y, z): return Vector3(y+z, z+x, x+y)
	],
	"rotarycubed": [
		func(x, y, z): return Vector3((-y+z)**3, (-z+x)**3, (-x+y)**3), 
		func(x, y, z): return Vector3(0, 0, 0),
		func(x, y, z): return 0, 
		func(x, y, z): return Vector3(0, 0, 0)
	],
	"scalar": [
		func(x, y, z): return x**2 + y**2 - z**2, 
		func(x, y, z): return Vector3(2*x, 2*y, -2*z),
		func(x, y, z): return 0, 
		func(x, y, z): return Vector3(0, 0, 0)
	],
}

var state = {
	"paused": false,
	"sections": []
}

@onready var PL: Dictionary[String, PackedScene] = { # preloads
	"vec": preload("res://Scenes/display_vector.tscn"),
	"pt": preload("res://Scenes/point.tscn")
}

@onready var ROOT_WORLD = get_tree().root.get_node("World")
@onready var ROOT_SCENE
@onready var WORLD

@onready var CAMERA

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if ROOT_WORLD:
		ROOT_SCENE = ROOT_WORLD.get_node("Scene")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
#
#func refresh_world():
	#WORLD = ROOT_WORLD.get_child(0).get_child(0)
