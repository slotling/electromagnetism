extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var callable = Callable(self, "m").bind(5)
	
func m(x, y, z, a, b, c):
	return x * y


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
