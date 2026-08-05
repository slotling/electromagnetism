extends CanvasLayer

@export var testCharge: NodePath

func _ready() -> void:
	G.WORLD.FieldUpdatedSignal.connect(update)

var electric_field = Vector3.ZERO

func _process(delta: float) -> void:
	if get_node(testCharge).is_updated():
		update()

func update():
	electric_field = get_node(testCharge).get_node("./TestChargeCalculationController").calculate()
	
	$Label.text = "Electric field at test charge: < [color='#FFFF00']"
	$Label.text += G.format_number(electric_field.x, 3)
	$Label.text += "[/color] , [color='#FF00FF']"
	$Label.text += G.format_number(electric_field.y, 3)
	$Label.text += "[/color] , [color='#00FFFF']"
	$Label.text += G.format_number(electric_field.z, 3)
	$Label.text += "[/color] > N/C"
	#$CanvasLayer/Label.text += "\nDebug in-game position: <"
	#$CanvasLayer/Label.text += str(int($TestCharge/PointCharge.global_position.x))
	#$CanvasLayer/Label.text += " , "
	#$CanvasLayer/Label.text += str(int($TestCharge/PointCharge.global_position.y))
	#$CanvasLayer/Label.text += " , "
	#$CanvasLayer/Label.text += str(int($TestCharge/PointCharge.global_position.z))
	#$CanvasLayer/Label.text += ">"
