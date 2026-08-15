extends CanvasLayer

@export var SurfaceIntegralCalculationController: NodePath

func _ready() -> void:
	#G.WORLD.FieldUpdatedSignal.connect(update)
	pass
	
func update():
	$Label.text = "Flux: [color='#FF00AE']thinking very hard..."
	await get_tree().process_frame
	#await get_tree().process_frame
	var result = await get_node(SurfaceIntegralCalculationController).calculate()
	$Label.text = "Flux: [color='#FFFF00']"
	$Label.text += G.format_number(result, 5)
	$Label.text += "[/color]"

func _on_button_pressed() -> void:
	update()
