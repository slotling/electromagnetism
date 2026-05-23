extends Oscillator

@onready var params_2 = {
	"F_extra": 100
}

@onready var calc_params = {
	"amp": state["x"] - params_2["F_extra"] / cons["k"],
	"t_off": 0
}

func physics(_dt):
	state["x"] = calc_params["amp"] * cos(sqrt(cons["k"] / cons["m"]) * state["t"] + calc_params["t_off"]) + params_2["F_extra"] / cons["k"]
	# for display
	state["x."] = calc_params["amp"] * -sin(sqrt(cons["k"] / cons["m"]) * state["t"] + calc_params["t_off"]) * sqrt(cons["k"] / cons["m"])
	state["x.."] = calc_params["amp"] * -cos(sqrt(cons["k"] / cons["m"]) * state["t"] + calc_params["t_off"]) * cons["k"] / cons["m"]

#
#func physics(delta: float) -> void:
	#var dt = delta * 10.0
	#params["F"] = - cons["k"] * state["x"] + params_2["F_extra"]
	#state["x.."] = params["F"] / cons["m"]
	#state["x."] += state["x.."] * dt
	#state["x"] += state["x."] * dt
