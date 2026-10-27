extends CanvasLayer

@export var SurfaceIntegralCalculationControllerNode: NodePath

@export var ButtonsToBePressed: Array[NodePath]

func _ready() -> void:
	#G.WORLD.FieldUpdatedSignal.connect(update)
	pass
	
func update():
	for i in ButtonsToBePressed:
		get_node(i).pressed.emit()
	
	$Label.text = "Flux: [color='#FF00AE']thinking very hard..."
	await get_tree().process_frame
	#await get_tree().process_frame
	var result = await get_node(SurfaceIntegralCalculationControllerNode).calculate()
	$Label.text = "Flux: [color='#FFFF00']"
	$Label.text += G.format_number(result, 5)
	#$Label.text += "[/color]"

func _on_button_pressed() -> void:
	update()
