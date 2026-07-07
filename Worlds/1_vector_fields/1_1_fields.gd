extends Node3D
class_name VectorField

@export var config: WorldConfig = WorldConfig.new()

@onready var calculated_settings = {
	"max": Vector3.ZERO,
	"magmax": 0,
	"min": Vector3.ZERO,
}

var drawing_list = []

func F(x, y=0, z=0) -> Vector3:
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
				var pos := config.draw.PosScale * Vector3(ix, iy, iz)
				
				drawing_list.append([value, pos])
				
				calculated_settings["max"] = calculated_settings["max"].max(value)
				calculated_settings["magmax"] = max(calculated_settings["magmax"], value.length())
				calculated_settings["min"] = calculated_settings["min"].min(value)
	
	draw_vectors(0, true)

var cycle_length = 1

func draw_vectors(curtime=0, init=false):
	var MM = $MM.multimesh
	
	var instances_dim := config.draw.LatticeEnd + Vector3.ONE - config.draw.LatticeStart
	var instance_count := instances_dim.x * instances_dim.y * instances_dim.z
	
	if init:
		MM.transform_format = MultiMesh.TRANSFORM_3D
		MM.instance_count = instance_count
		MM.visible_instance_count = instance_count

	for i in instance_count:
		var info = drawing_list[i]
		var transformation = Basis.looking_at(info[0], Vector3(0, 0, -1))
		
		if init:
			var offset = randf_range(0, 1)
			MM.set_instance_custom_data(i, Color(offset * cycle_length, 0, 0, 0))
		
		var magnitude = info[0].length()
		
		var finalscale = Vector3.ONE * max((config.draw.MinSize if (magnitude != 0 or config.type == 3) else 0.0), magnitude / calculated_settings["magmax"] * config.draw.BaseSize) * config.draw.MultSize
		transformation = transformation.scaled(Vector3.ONE * finalscale)
		
		# timeoffset: 0 to 1, progress through anim
		var timeoffset = curtime + MM.get_instance_custom_data(i).r 
		timeoffset = (timeoffset - int(timeoffset/cycle_length))/cycle_length
		
		var moveoffset = info[0].normalized() * ((timeoffset - 0.5) * (finalscale)) * 10
		
		var transpoint = (info[0] - calculated_settings["min"]) / (calculated_settings["max"] - calculated_settings["min"])
		
		var alpha = 1
		if timeoffset < 0.2:
			alpha = timeoffset * 5
		elif timeoffset > 0.8:
			alpha = timeoffset * -5 + 5
		
		var color = Color(transpoint.x, transpoint.y, transpoint.z, alpha)
		
		MM.set_instance_color(i, color)
		MM.set_instance_transform(i, Transform3D(transformation, info[1] + moveoffset))
		# Color(transpoint.x, transpoint.x, 1 - transpoint.x, material.albedo_color.a)

var frame = 0
var time = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	frame += 1
	time += delta
	draw_vectors(time)
