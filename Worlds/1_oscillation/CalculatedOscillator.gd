extends Oscillator

@onready var calc_params = {
	"amp": state["x"],
	"t_off": 0
}

func physics(_dt):
	state["x"] = calc_params["amp"] * cos(sqrt(cons["k"] / cons["m"]) * state["t"] + calc_params["t_off"])
	# for display
	state["x."] = calc_params["amp"] * -sin(sqrt(cons["k"] / cons["m"]) * state["t"] + calc_params["t_off"]) * sqrt(cons["k"] / cons["m"])
	state["x.."] = calc_params["amp"] * -cos(sqrt(cons["k"] / cons["m"]) * state["t"] + calc_params["t_off"]) * cons["k"] / cons["m"]
