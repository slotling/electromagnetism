extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var callable = Callable(self, "m").bind(5)
	print(callable.call(2, 3, 4, 5, 6))
	
func m(x, y, z, a, b, c):
	print(x, y, z, a, b, c)
	return x * y


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
