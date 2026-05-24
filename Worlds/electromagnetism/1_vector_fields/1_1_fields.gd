extends Node3D

@export var config: WorldConfig = WorldConfig.new()

@onready var calculated_settings = {
	"max": Vector3.ZERO,
	"magmax": 0,
	"min": Vector3.ZERO,
}

var drawing_list = []

func F(x, y, z) -> Vector3:
	return Vector3(cos(y), cos(x), 0)
	# Vector3(sin(x), sin(y), sin(z))
	# Vector3(x, y, z)
	# Vector3(cos(y), cos(x), 0)
	# Vector3(-y+z, -z+x, -x+y)
	# Vector3((-y+z)**3, (-z+x)**3, (-x+y)**3)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#await get_tree().process_frame # wait 1 frame to ensure all of the export variables of this world is read, not the previous one
		
	for ix in range(config.ends_f.x, config.ends_t.x+1, config.step):
		for iy in range(config.ends_f.y, config.ends_t.y+1, config.step):
			for iz in range(config.ends_f.z, config.ends_t.z+1, config.step):
				#if ix**2+iy**2+iz**2 > 30:
					#continue
				
				var x = config.valscale * ix
				var y = config.valscale * iy
				var z = config.valscale * iz
				var value := F(x, y, z)
				var pos := Vector3(ix*config.posscale, iy*config.posscale, iz*config.posscale)
				
				drawing_list.append([value, pos])
				
				calculated_settings["max"] = calculated_settings["max"].max(value)
				calculated_settings["magmax"] = max(calculated_settings["magmax"], value.length())
				calculated_settings["min"] = calculated_settings["min"].min(value)
	
	draw_vectors()

# Increment the value from the thread, too.
func draw_vectors():
	await get_tree().process_frame
	for i in drawing_list:
		var vec: DisVec = G.PL["vec"].instantiate()
		vec.init(i[0], i[1], config.type)
		add_child(vec)

var frame = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	frame+=1
