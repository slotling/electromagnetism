extends Node2D
class_name Oscillator

@onready var state = {
	"x": 500.0,
	"x.": 0.0,
	"x..": 0.0,
	"t": 0.0,
}

@onready var params = {
	"F": 0.0
}

@onready var cons = {
	"m": 10.0,
	"k": 1
}

func _ready() -> void:
	#state = {
		#"x": 500.0,
		#"x.": 0.0,
		#"x..": 0.0,
		#"t": 0.0,
	#}
	ready()

func ready():
	pass

func _process(delta: float) -> void:
	var dt = delta * 10
	$Sprite/Label.text = ""
	for i in state:
		if state[i] == null:
			continue
		$Sprite/Label.text += i + " = " + "%.2f" % state[i] + "\n"
	$Sprite.position.x = state.x
	
	if G.state["paused"]:
		return
	state["t"] += dt
	physics(dt)
	
func physics(dt):
	params["F"] = - cons["k"] * state["x"]
	state["x.."] = params["F"] / cons["m"]
	state["x."] += state["x.."] * dt
	state["x"] += state["x."] * dt
