extends Oscillator

@onready var params_2 = {
	"F_extra": 100,
	"F_drag": 100
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _process(delta: float) -> void:
	var dt = delta * 10.0
	params["F"] = - cons["k"] * state["x"] + params_2["F_extra"]
	state["x.."] = params["F"] / cons["m"]
	state["x."] += state["x.."] * dt
	state["x"] += state["x."] * dt
	position.x = state.x
