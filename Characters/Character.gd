extends Node2D

# キャラクターのステータスを保持する辞書
var status = {
	"name": "名無し",
	"true_name": "",
	"level": 1,
	"experience": 0,
	"hp": 1,
	"mp": 0,
	"skills": {}
}

# ノードがシーンツリーに初めて入ったときに呼び出される
func _ready():
	pass # Replace with function body.

# 辞書を引数に取り、キャラクターのステータスを初期化する
func initialize(dict):
	for key in dict.keys():
		if not status.has(key):
			print("Warnig: " + str(key) + "はstatusに存在しません。")
		status[key] = dict[key]

# 毎フレーム呼び出される。'delta'は前のフレームからの経過時間
func _process(delta):
	pass
