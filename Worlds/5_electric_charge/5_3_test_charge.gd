extends ChargeVectorField
#
func _ready() -> void:
	super()
	#await get_tree().process_frame
	update()

var electric_field = Vector3.ZERO

func _process(delta: float) -> void:
	super(delta)
	if $TestCharge/PointCharge.is_updated():
		update()

func update_charge(charge_id, update_drawing_list, refresh_config=false):
	super(charge_id, update_drawing_list, refresh_config)
	update()

func update():
	electric_field = Vector3.ZERO
	var pos = $TestCharge/PointCharge.get_logical_position()
	for charge in charges:
		electric_field += charge.E(pos.x, pos.y, pos.z)
	
	$CanvasLayer/Label.text = "Electric field at test charge: < [color='#FFFF00']"
	$CanvasLayer/Label.text += G.format_number(electric_field.x, 3)
	$CanvasLayer/Label.text += "[/color] , [color='#FF00FF']"
	$CanvasLayer/Label.text += G.format_number(electric_field.y, 3)
	$CanvasLayer/Label.text += "[/color] , [color='#00FFFF']"
	$CanvasLayer/Label.text += G.format_number(electric_field.z, 3)
	$CanvasLayer/Label.text += "[/color] > N/C"
	#$CanvasLayer/Label.text += "\nDebug in-game position: <"
	#$CanvasLayer/Label.text += str(int($TestCharge/PointCharge.global_position.x))
	#$CanvasLayer/Label.text += " , "
	#$CanvasLayer/Label.text += str(int($TestCharge/PointCharge.global_position.y))
	#$CanvasLayer/Label.text += " , "
	#$CanvasLayer/Label.text += str(int($TestCharge/PointCharge.global_position.z))
	#$CanvasLayer/Label.text += ">"
