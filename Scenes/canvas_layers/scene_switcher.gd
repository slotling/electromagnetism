extends CanvasLayer

var scenes = []
var scenes_loaded = []
var current_scene = null

func init(options: Dictionary, default_index=0) -> void: # name, nodepath
	$OptionButton.clear()
	for i in options.keys():
		$OptionButton.add_item(i)
	scenes = options.values()
	$OptionButton.select(default_index)
	_on_option_button_item_selected(default_index)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

@export var freeScene = false
func _on_option_button_item_selected(index: int) -> void:
	if freeScene:
		var child = G.ROOT_WORLD.get_node("Scene").get_child(0)
		if child != null:
			child.queue_free()
		scenes_loaded = []
	
	for i in G.ROOT_SCENE.get_children():
		i.visible = false
		for j in i.get_children():
			if "visible" in j:
				j.visible = false
	
	var loaded_find = scenes_loaded.find(index)
	if loaded_find == -1:
		var NEW_WORLD = scenes[index].instantiate()
		G.WORLD = NEW_WORLD
		G.ROOT_SCENE.add_child(NEW_WORLD)
		scenes_loaded.append(index)
	else:
		var EXISTING_WORLD = G.ROOT_SCENE.get_children()[loaded_find]
		EXISTING_WORLD.visible = true
		for j in EXISTING_WORLD.get_children():
			j.visible = true
		G.WORLD = EXISTING_WORLD
