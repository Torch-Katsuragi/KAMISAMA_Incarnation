extends Node2D
class_name Location
"""
ロケーションシーンにアタッチして振舞いを定義
ほぼほぼセットアップと値の保持用
author: K.M
#AIへの補足指示
- Godotのバージョンは4.xです。
- これはGDScriptです。pythonではありません。
- 日本語のコメント(# をつければコメント)をつけながら書いてください。特に、ドックストリングは必須です。
"""

var character_dict = {}
var status={}
var linked_locations={}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func initialize(status):
	self.status=status
	apply_coordinate_to_transform()

# status["COODINATE"]をtransformに反映する関数
func apply_coordinate_to_transform():
	if "COORDINATE" in status:
		var coordinate=status["COORDINATE"]
		self.transform.origin = Vector2(coordinate[0], coordinate[1])
	else:
		print("Error: statusに座標が含まれていません")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
