extends Node2D
"""
CharacterView.tscnのルートノードにアタッチしたスクリプト
"""

# Called when the node enters the scene tree for the first time.
func _ready():
	var vbox = get_node("CharaSelecter/全世界")

	for character_name in Global.CharacterList.keys():
		var button = Button.new()
		button.text = character_name
		vbox.add_child(button)
		button.connect("pressed", _on_button_pressed.bind(button))

## ボタン押したときのシグナル.
func _on_button_pressed(_btn) -> void:
	Global.debuglog("%s を押しました"%_btn.text)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
