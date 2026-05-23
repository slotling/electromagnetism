extends Oscillator

@onready var params_2 = {
	"F_extra": 100
}

func physics(dt: float) -> void:
	params["F"] = - cons["k"] * state["x"] + params_2["F_extra"]
	state["x.."] = params["F"] / cons["m"]
	state["x."] += state["x.."] * dt
	state["x"] += state["x."] * dt
