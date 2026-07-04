extends Node3D
var t_start = 0
var t_end = 1000
var ValScale = 0.01
var PosScale = 25

func F(t):
	return Vector3(cos(t), sin(5*t), sin(t))

func _on_ready() -> void:
	for i in range(t_start, t_end, 1):
		var t = i*ValScale
		var pos = F(t) * PosScale
		$Path3D.curve.add_point(pos)
		var point = G.PL["pt"].instantiate()
		point.init(pos)
		G.WORLD.add_child.call_deferred(point)
		#print(i, t, F(t))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
