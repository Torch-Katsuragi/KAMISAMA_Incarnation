extends Node
"""
author: KM
MainにアタッチしてGUIの制御を担当
"""

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _day_execute():
	World.execute()

func _save_savedata():
	World.debuglog("save start")
	World.save_savedata()
	pass
