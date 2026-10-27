extends Node3D
class_name VectorField

@export var config: WorldConfig = WorldConfig.new()

signal FieldUpdatedSignal

@onready var calculated_settings = {
	"x_values": [],
	"y_values": [],
	"z_values": [],
	"magnitudes": [],
	"max": Vector3.ZERO,
	"magmax": 0,
	"min": Vector3.ZERO,
	"instance_count": 0
}

var drawing_list = []

@export var FieldScript: Script
@onready var FieldScriptInstance: FunctionController = FieldScript.new() if FieldScript != null else null

# Alias variable name for FunctionInput nodes and consistency
@onready var FunctionScriptInstances = [FieldScriptInstance]
func function_updater():
	create_drawing_list(true)
	draw_vectors(0, true)
	#print(calculated_settings["magmax"])

func F(x, y=0, z=0, id=null) -> Vector3:
	return FieldScriptInstance.F(x, y, z, id)

func add_drawing_object(x, y, z, value: Vector3, initialize):
	var ix = float(x) / float(config.draw.ValScale)
	var iy = float(y) / float(config.draw.ValScale)
	var iz = float(z) / float(config.draw.ValScale)
	var pos := config.draw.PosScale * Vector3(ix, iy, iz)
	pos = G.reorient_to_game(pos)
	var val = G.reorient_to_game(value)
			
	drawing_list.append([val, pos])
	
	if initialize:
		calculated_settings["x_values"].append(val.x)
		calculated_settings["y_values"].append(val.y)
		calculated_settings["z_values"].append(val.z)
		calculated_settings["magnitudes"].append(val.length())

func loop_through_all_points(initialize: bool, callable: Callable):
	var id = 0
	for ix in range(config.draw.LatticeStart.x, config.draw.LatticeEnd.x+1, 1):
		for iy in range(config.draw.LatticeStart.y, config.draw.LatticeEnd.y+1, 1):
			for iz in range(config.draw.LatticeStart.z, config.draw.LatticeEnd.z+1, 1):
				var x = config.draw.ValScale * ix
				var y = config.draw.ValScale * iy
				var z = config.draw.ValScale * iz
				callable.call(x, y, z, id, {"initialize": initialize})
				id += 1

func every_point(x, y, z, id, extra):
	var value: Vector3 = F(x, y, z, id)
	
	const straddleInfArrowsCount = 1
	var valSlightChange = config.draw.ValScale * 0.5
	for xi in range(-straddleInfArrowsCount, straddleInfArrowsCount+1) if is_inf(value.x) else range(1):
		for yi in range(-straddleInfArrowsCount, straddleInfArrowsCount+1) if is_inf(value.y) else range(1):
			for zi in range(-straddleInfArrowsCount, straddleInfArrowsCount+1) if is_inf(value.z) else range(1):
				var newx = x + valSlightChange * xi
				var newy = y + valSlightChange * yi
				var newz = z + valSlightChange * zi
				var new_value: Vector3 = F(newx, newy, newz, id)
				calculated_settings["instance_count"] += 1
				add_drawing_object(newx, newy, newz, new_value, extra["initialize"])

func create_drawing_list_process(initialize) -> void:
	if initialize:
		calculated_settings["x_values"] = []
		calculated_settings["y_values"] = []
		calculated_settings["z_values"] = []
		calculated_settings["magnitudes"] = []
		calculated_settings["instance_count"] = 0
	
	loop_through_all_points(initialize, Callable(self, "every_point"))
	
	if initialize and drawing_list.size() != 0:
		var length = calculated_settings["x_values"].size()
		var upper_percentile_index = int(length / 100.0 * config.draw.UpperPercentile)
		var lower_percentile_index = length / 100.0 * config.draw.LowerPercentile
		calculated_settings["x_values"].sort()
		calculated_settings["y_values"].sort()
		calculated_settings["z_values"].sort()
		calculated_settings["magnitudes"].sort()
		calculated_settings["max"] = Vector3(calculated_settings["x_values"][upper_percentile_index], calculated_settings["y_values"][upper_percentile_index], calculated_settings["z_values"][upper_percentile_index])
		calculated_settings["magmax"] = calculated_settings["magnitudes"][upper_percentile_index]
		calculated_settings["min"] = Vector3(calculated_settings["x_values"][lower_percentile_index], calculated_settings["y_values"][lower_percentile_index], calculated_settings["z_values"][lower_percentile_index])
	
# THIS IS WHAT YOU CALL TO REFRESH THE DRAWING LIST
func create_drawing_list(initialize) -> void:
	drawing_list = []
	create_drawing_list_process(initialize)
	FieldUpdatedSignal.emit()
	draw_vectors(time)
	
func get_instance_count():
	var instances_dim := config.draw.LatticeEnd + Vector3.ONE - config.draw.LatticeStart
	return instances_dim.x * instances_dim.y * instances_dim.z if not calculated_settings else calculated_settings["instance_count"]

@export var autoRenderOnReady = false
func _ready() -> void:
	await get_tree().process_frame
	FieldScriptInstance.WORLD = self
	
	if autoRenderOnReady:
		create_drawing_list(true)
		draw_vectors(0, true)

var cycle_length = 1

func draw_vectors(curtime=0, init=false):
	var MM = $MM.multimesh
	
	var instance_count = get_instance_count()
	
	if init:
		MM.transform_format = MultiMesh.TRANSFORM_3D
		MM.instance_count = instance_count
		MM.visible_instance_count = instance_count

	for i in instance_count:
		var info = drawing_list[i]
		if info[0] == Vector3.ZERO:
			MM.set_instance_color(i, Color("TRANSPARENT"))
			continue
		var transformation = Basis.looking_at(info[0], Vector3(0, 0, -1))
		
		if init:
			var offset = randf_range(0, 1)
			MM.set_instance_custom_data(i, Color(offset * cycle_length, 0, 0, 0))
		
		var magnitude = info[0].length()
		var finalscale = Vector3.ONE * min(max(config.draw.MinSize, magnitude / calculated_settings["magmax"] * config.draw.BaseSize) if not is_zero_approx(magnitude) else 0.0, config.draw.MaxSize) * config.draw.MultSize
		transformation = transformation.scaled(Vector3.ONE * finalscale)
		
		# timeoffset: 0 to 1, progress through anim
		var timeoffset = curtime + MM.get_instance_custom_data(i).r 
		timeoffset = (timeoffset - int(timeoffset/cycle_length))/cycle_length
		
		var moveoffset = info[0].normalized() * ((timeoffset - 0.5) * (finalscale)) * 10 # timeoffset - 0.5 for central
		
		var value_range = calculated_settings["max"] - calculated_settings["min"]
		var transpoint = (info[0] - calculated_settings["min"]) / value_range
		transpoint.x = 0 if transpoint.x == null else transpoint.x
		transpoint.y = 0 if transpoint.y == null else transpoint.y
		transpoint.z = 0 if transpoint.z == null else transpoint.z
		transpoint.x = clamp(transpoint.x, 0, 1)
		transpoint.y = clamp(transpoint.y, 0, 1)
		transpoint.z = clamp(transpoint.z, 0, 1)
		
		var alpha = 1
		if timeoffset < 0.2:
			alpha = timeoffset * 5
		elif timeoffset > 0.8:
			alpha = timeoffset * -5 + 5
		
		var color = Color(transpoint.x, transpoint.y, transpoint.z, alpha) * config.draw.ColorMult
		
		MM.set_instance_color(i, color)
		MM.set_instance_transform(i, Transform3D(transformation, info[1] + moveoffset))
		# Color(transpoint.x, transpoint.x, 1 - transpoint.x, material.albedo_color.a)

var frame = 0
var time = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	frame += 1
	if not config.draw.LowDetailMode and G.WORLD == self and drawing_list.size() != 0:
		time += delta
		draw_vectors(time)
