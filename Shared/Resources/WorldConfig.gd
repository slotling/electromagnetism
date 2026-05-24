extends Resource
class_name WorldConfig
@export var step := 1
@export var ends_f := Vector3(-5, -5, -5) # ends from
@export var ends_t := Vector3(5, 5, 5) # ends to
@export var posscale := 10.0 # spreading of positions
@export var valscale := 10.0 # logical multiplier to input values (doesn't affect appearance)
@export var baseSize := 2.0 # size of maximum vector
@export var multSize := 1.0 # final size multiplier
@export var minSize := 1.0 # lower bound of size
@export_enum("vector", "scalar", "divergence", "curl") var type: int = 0
