extends Resource
class_name DrawConfig

# A visual representation of a vector field. A lattice of vectors is drawn. 

# Each point in the lattice has associated values:
# 1. Raw Index (Vector3)
@export var LatticeStart := Vector3(-5, -5, -5) # Loop startings for generating lattice points
@export var LatticeEnd := Vector3(5, 5, 5) # Loop endings for generating lattice points

# 2. Position (Vector3, inferred from Raw Index)
@export var PosScale := 10.0 # Multiplied with Raw Index to get position for in-world drawing

# 3. Numerical Input (Vector3, inferred from Raw Index)
@export var ValScale := 10.0 # Multiplied with Raw Index to get input values for multivariable functions

# Each lattice point has a vector drawn at that position. 
# Each vector's scale depends on its magnitude.
# The scaling can be configured here.
@export var BaseSize := 1.0 # Size of vector with maximum magnitude. All other vectors are scaled proportionally.
@export var MinSize := 0.01 # Lower bound of size for nonzero vectors.
@export var MaxSize := 3.0 # Upper bound of size for vectors.
@export var MultSize := 0.5 # Multiplied with post-processed scale of each vector.

@export var UpperPercentile = 80
@export var LowerPercentile = 20

@export var ColorMult = 0.8

# Additional configurations
@export var LowDetailMode := false # When true, disables moving animations of vectors.
