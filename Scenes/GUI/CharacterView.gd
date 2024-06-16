extends Node2D
"""
Author: K.M
CharacterView.tscnのルートノードにアタッチしたスクリプト

#AIへの補足指示
- Godotのバージョンは4.xです。
- これはGDScriptです。pythonではありません。
- 日本語のコメントをつけながら書いてください。特に、ドックストリングは必須です。
"""

var detail_root_node=null
var portrait_node=null
var status_node = null
var status_name_node = null
var status_value_node = null

# Called when the node enters the scene tree for the first time.
func _ready():
	var vbox = get_node("CharaSelecter/全世界")
	detail_root_node=get_node("CharaDetail")
	status_node=detail_root_node.get_node("Status")
	portrait_node=detail_root_node.get_node("Portrait")
	status_name_node = status_node.get_node("StatusName")
	status_value_node = status_node.get_node("StatusValue")

	for character_name in World.character_dict.keys():
		var button = Button.new()
		var chara=World.character_dict[character_name]
		button.text =chara.nickname
		vbox.add_child(button)
		button.connect("pressed", _on_button_pressed.bind(button,chara))
	
	

# ボタンが押されたときに呼び出されるシグナルのハンドラ
func _on_button_pressed(_btn,chara) -> void:
	# 選択されたキャラクターの真名をデバッグログに出力
	World.debuglog("真名：%sを選択"%chara.true_name)
	# キャラクターの所属するグループ一覧を取得して表示
	var groups = chara.get_groups()
	World.debuglog("グループ一覧: %s" % str(groups))
	# 選択されたキャラクターの詳細を更新
	_update_detail(chara)

# キャラクターの詳細を更新する関数
func _update_detail(chara):
	# "StatusName"ノードをクリア

	# 詳細情報を初期化
	for node in [status_name_node,status_value_node]:
		for child in node.get_children():
			node.remove_child(child)
			child.queue_free()
	
	# portrait_nodeだけはcharacterをそのまま表示しているのでメモリフリーせずに初期化
	for child in portrait_node.get_children():
		portrait_node.remove_child(child)

	var status=chara.get_dict()
	
	# キャラクターのステータスをラベルとして表示
	for key in status.keys():
		var status_name = Label.new()
		var status_value = Label.new()
		status_name.text = key
		status_value.text = str(status[key])
		status_name_node.add_child(status_name)
		status_value_node.add_child(status_value)
	
	# キャラクターをdetail_root_nodeに追加してportrait表示
	portrait_node.add_child(chara)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

