extends CanvasLayer

@export var surface: NodePath

func _ready() -> void:
	G.WORLD.FieldUpdatedSignal.connect(update)
	
func update():
	var result = await get_node(surface).get_node("./SurfaceIntegralCalculationController").calculate()
	$Label.text = "Flux: [color='#FFFF00']"
	$Label.text += G.format_number(result, 5)
	$Label.text += "[/color]"
