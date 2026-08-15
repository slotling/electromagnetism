extends Resource
class_name FunctionController
# Extend script to add your own function and modify starting and ending values for parameters!!!

var WORLD = null

var ustart = 0.0
var uend = 1.0
var vstart = 0.0
var vend = 1.0
var wstart = 0.0
var wend = 1.0
var render_diff = 0.01
var calculation_diff = 0.01

# Functions are divided based on physical significance, number of input variables, and number of outputs.

# FIELDS
# - a parametric path: (u) -> (x, y, z)
# - a parametric surface: (u, v) -> (x, y, z)
func F(x, y=0, z=0, id=null) -> Vector3:
	return Vector3.ZERO

# PARAMETRIC
# - a vector field: (x, y, z) -> (x, y, z)
# - a scalar field: (x, y, z) -> (a)
func R(u, v=0, w=0) -> Vector3:
	return Vector3.ZERO
	
# PARTIAL DERIVATIVES FOR PARAMETRIC LINES AND SURFACES
# - Infinitesimal displacement vector functions with respect to parameters u and v
# (u) -> (x, y, z)
# (u, v) -> (x, y, z)
func R_u(u, v=0) -> Vector3:
	return Vector3.ZERO
	
func R_v(u, v) -> Vector3:
	return Vector3.ZERO

# DENSITIES
# - a parametric scalar path: (u) -> (a)
# - a parametric scalar surface: (u, v) -> (a)
# - a parametric scalar volume: (u, v, w) -> (a)
# - a density scalar field: (x, y, z) -> (a)
func P(u, v=0, w=0) -> float: # for densities
	return 0.0

func _ready() -> void:
	pass
