extends CanvasLayer

var scenes = []

func init(options: Dictionary[String, Resource]) -> void: # name, nodepath
	$OptionButton.clear()
	for i in options.keys():
		$OptionButton.add_item(i)
	scenes = options.values()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_option_button_item_selected(index: int) -> void:
	G.ROOT_WORLD.get_node("Scene").get_child(0).queue_free()
	G.ROOT_WORLD.get_node("Scene").add_child(scenes[index].instantiate())
