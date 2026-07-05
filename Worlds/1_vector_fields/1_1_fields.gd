extends Node3D
class_name VectorField

@export var config: WorldConfig = WorldConfig.new()

@onready var calculated_settings = {
	"max": Vector3.ZERO,
	"magmax": 0,
	"min": Vector3.ZERO,
}

var drawing_list = []

func F(x, y, z) -> Vector3:
	var evaluation = G.FUNCTIONS[G.current_function_index][config.subfunction_choice].call(x, y, z)
	return evaluation if typeof(evaluation) == TYPE_VECTOR3 else Vector3(evaluation, 0, 0)

func _ready() -> void:
	for ix in range(config.draw.LatticeStart.x, config.draw.LatticeEnd.x+1, 1):
		for iy in range(config.draw.LatticeStart.y, config.draw.LatticeEnd.y+1, 1):
			for iz in range(config.draw.LatticeStart.z, config.draw.LatticeEnd.z+1, 1):
				#if ix**2+iy**2+iz**2 > 30:
					#continue
				
				var x = config.draw.ValScale * ix
				var y = config.draw.ValScale * iy
				var z = config.draw.ValScale * iz
				var value := F(x, y, z)
				var pos := Vector3(ix*config.draw.PosScale, iy*config.draw.PosScale, iz*config.draw.PosScale)
				
				drawing_list.append([value, pos])
				
				calculated_settings["max"] = calculated_settings["max"].max(value)
				calculated_settings["magmax"] = max(calculated_settings["magmax"], value.length())
				calculated_settings["min"] = calculated_settings["min"].min(value)
	
	draw_vectors()

func draw_vectors():
	#await get_tree().process_frame
	#for i in drawing_list:
		#var vec: DisVec = G.PL["vec"].instantiate()
		#vec.init(i[0], i[1], config.type)
		#add_child(vec)
	
	 #Set the format first.
	$MM.multimesh.transform_format = MultiMesh.TRANSFORM_3D
	
	var instances_dim := config.draw.LatticeEnd + Vector3.ONE - config.draw.LatticeStart
	var instance_count := instances_dim.x + instances_dim.y + instances_dim.z
	$MM.multimesh.instance_count = instance_count
	$MM.multimesh.visible_instance_count = instance_count
	
	for i in $MM.multimesh.visible_instance_count:
		$MM.multimesh.set_instance_transform(i, Transform3D(Basis(), Vector3(i * 20, 0, 0)))

var frame = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	frame+=1
