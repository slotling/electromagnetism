extends Resource
class_name DrawConfig

# A visual representation of a vector field. A lattice of vectors is drawn. 

# Each point in the lattice has associated values:
# 1. Raw Index (Vector3)
## Loop startings for generating lattice points
## Loop endings for generating lattice points
@export var LatticeStart := Vector3(-5, -5, -5)
@export var LatticeEnd := Vector3(5, 5, 5) 

# 2. Position (Vector3, inferred from Raw Index)
## Multiplied with Raw Index to get position for in-world drawing
@export var PosScale := 10.0 

# 3. Numerical Input (Vector3, inferred from Raw Index)
## Multiplied with Raw Index to get input values for multivariable functions
@export var ValScale := 10.0 

# Each lattice point has a vector drawn at that position. 
# Each vector's scale depends on its magnitude.
# The scaling can be configured here.
## Size of vector with maximum magnitude. All other vectors are scaled proportionally.
@export var BaseSize := 1.0 
## Lower bound of size for nonzero vectors.
@export var MinSize := 0.01 
## Upper bound of size for vectors.
@export var MaxSize := 3.0 
## Multiplied with post-processed scale of each vector.
@export var MultSize := 0.5 

@export var UpperPercentile = 80
@export var LowerPercentile = 20

@export var ColorMult = 0.8

# Additional configurations
## When true, disables moving animations of vectors.
@export var LowDetailMode := false
