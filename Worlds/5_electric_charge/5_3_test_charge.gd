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

func update():
	electric_field = Vector3.ZERO
	var pos = $TestCharge/PointCharge.get_logical_position()
	for charge in charges:
		electric_field += charge.E(pos.x, pos.y, pos.z)
	
	$CanvasLayer/Label.text = "Electric field at test charge: < [color='#FFFF00']" + G.format_number(electric_field.x, 3) + "[/color] ,  [color='#FF00FF']" + G.format_number(electric_field.y, 3) + "[/color] , [color='#00FFFF']" + G.format_number(electric_field.z, 3) + "[/color] >"
