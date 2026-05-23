extends Camera3D

@export var orbital_speed = PI/10
var orbit_yaw = 0
var orbit_roll = deg_to_rad(45)
var orbit_horizontal_distance = 200

var movement: Vector2
func _input(event):
	if event is InputEventMouseMotion:
		movement = event.relative

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("click"):
		#print("a")
		orbital_speed = 0
		get_parent().rotation.y += movement.x * -0.01
		#get_parent().rotation.z += movement.y * -0.01
		movement = Vector2.ZERO
		
	if orbital_speed != 0:
		look_at(Vector3.ZERO)
		get_parent().get_node("DirectionalLight3D").look_at(Vector3.ZERO)
		orbit_yaw += orbital_speed * delta
		get_parent().rotation.y = orbit_yaw
		#print(position)
