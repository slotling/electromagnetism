extends Node

var state = {
	"paused": false,
	"sections": []
}

@onready var PL: Dictionary[String, PackedScene] = { # preloads
	#"vec": preload("res://Scenes/display_vector.tscn"),
	#"pt": preload("res://Scenes/point.tscn")
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
	
func reorient_to_game(v: Vector3):
	return Vector3(v.x, v.z, -v.y)
	
func reorient_to_conventional(v: Vector3):
	return Vector3(v.x, -v.z, v.y)

var superscript = "⁰¹²³⁴⁵⁶⁷⁸⁹"
func number_to_superscript(num: int) -> String:
	var final = ""
	for i in str(num):
		if i == "-":
			final += "⁻"
			continue
		final += superscript[int(i)]
	return final

func format_number(num: float, sig_figs: int) -> String:
	if is_nan(num):
		return "NaN"
	
	var raw = str(num).replace(".", "")
	var negative_offset = 0 if num > 0 else 1
	if num == 0.0 or sig_figs <= 0:
		return "0." + "0".repeat(sig_figs-1) + " ⋅ 10⁰"
	var d = floor(log(abs(num)) / log(10.0))
	
	var most_sig_fig = negative_offset
	
	if d < 0:
		most_sig_fig += -d+1
		
	var final = ("-" if num < 0 else "") + raw[most_sig_fig] + "." + raw.substr(most_sig_fig+1, sig_figs-1)
	final += " ⋅ 10" + number_to_superscript(d) if d != 0 else ""
	
	return final
