extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	# ノード「Dummymap」を削除
	var dummymap = get_node("SubViewportContainer/SubViewport/MapCamera/DummyMap")
	if dummymap:
		var parent = dummymap.get_parent()
		dummymap.queue_free()
		# dummymapと同階層にWorld.mapを追加
		parent.add_child(World.map)
		# add_child(World.map)



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
