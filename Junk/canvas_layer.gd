extends CanvasLayer

var sim_paused = false
var sim_slow = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Paused.visible = false
	toggle_pause()
	reset()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

var dt = 0.01

func step() -> void:
	G.state["paused"] = false
	await get_tree().create_timer(Engine.time_scale * dt).timeout
	G.state["paused"] = true

func reset() -> void:
	for i in G.WORLD.get_children():
		var readyfunc = Callable(i, "_ready")
		if readyfunc.is_valid():
			readyfunc.call()
	#step()

func toggle_pause() -> void:
	sim_paused = !sim_paused
	G.state["paused"] = sim_paused
	$Button.text = "resume" if sim_paused else "pause"
	$Paused.visible = sim_paused
	$Resumed.visible = !sim_paused

func slow_toggle() -> void:
	sim_slow = !sim_slow
	$Button2.text = "faster" if sim_slow else "slower"
	Engine.time_scale = 0.1 if sim_slow else 1.0
	$Paused/Label.text = "dt = " + str(Engine.time_scale * dt)
