extends Oscillator


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

@onready var params_2 = {
	"F_extra": 1000
}

func physics(dt: float) -> void:
	params["F"] = - cons["k"] * state["x"] + params_2["F_extra"] * cos(state["t"])
	state["x.."] = params["F"] / cons["m"]
	state["x."] += state["x.."] * dt
	state["x"] += state["x."] * dt
