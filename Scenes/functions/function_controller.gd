extends Node
class_name FunctionController
# Attach as child of any function-requiring node:
# - a parametric path
# - a parametric surface
# - a vector field
# - a scalar field

# Extend script to add your own function!!!

@export var ustart = 0.0
@export var uend = 1.0
@export var vstart = 0.0
@export var vend = 1.0
@export var wstart = 0.0
@export var wend = 1.0
@export var diff = 0.01

func F(x, y=0, z=0) -> Vector3:
	return Vector3.ZERO

func R(u, v=0, w=0) -> Vector3:
	return Vector3.ZERO
