extends Resource
class_name WorldConfig

@export var draw: DrawConfig
@export_enum("vector", "scalar", "divergence", "curl") var type: int = 0 # visual type
@export_enum("default", "gradient", "divergence", "curl", "laplacian") var subfunction_choice: int = 0
