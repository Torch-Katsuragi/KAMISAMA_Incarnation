extends Node
"""
Author: K.M
ノードにはアタッチせず、シングルトンとして利用するスクリプト
プロジェクト全体を管理する処理をいろいろ書いていく。AIの参照先を増やすのが面倒なので、できるだけこのファイルで完結させたい

#AIへの補足指示
- Godotのバージョンは4.xです。
- これはGDScriptです。pythonではありません。
- 日本語のコメントをつけながら書いてください。特に、ドックストリングは必須です。
"""

# 定数をひとまとめに構造体で保存。こうすると予測変換がめっちゃ早くて楽
class STRUCT_CONST:
	# const WORKING_DIR="user://"
	const working_dir="res://"

	const save_data=working_dir+"SaveData.txt"

	# 0: all, 1: debug and info, 2: info only
	const debug_level=0

	class csene:
		const character=preload("res://Characters/Character.tscn")

# logging.debugの代わり
func debuglog(text):
	if STRUCT_CONST.debug_level<2:
		print(text)

# logging.infoの代わり
func infolog(text):
	if STRUCT_CONST.debug_level<3:
		print(text)

var true_name_list=["エレフローゼ", "アレスティオール"]

var CharacterList={}

# Called when the node enters the scene tree for the first time.
func _ready():
	character_born()
	var savedata=load_savedata()
	if "CharacterList" in savedata:
		for character_name in savedata["CharacterList"].keys():
			var character = STRUCT_CONST.csene.character.instantiate()

			character.initialize(savedata["CharacterList"][character_name])
			CharacterList[character.status["true_name"]] = character
	else:
		infolog("CharacterListがセーブデータに存在しません")
	

func load_savedata() -> Dictionary:
	if FileAccess.file_exists(STRUCT_CONST.save_data) == false:
		infolog("セーブデータが存在しません: %s"%STRUCT_CONST.save_data)
		return {}
		
	var f = FileAccess.open(STRUCT_CONST.save_data, FileAccess.READ)
	var text=f.get_as_text()
	debuglog(text)
	
	# ファイルを閉じる.
	f.close()
	return str_to_var(text)

func character_born():
	var character = STRUCT_CONST.csene.character.instantiate()
	var unique_true_name_list = []
	for true_name in true_name_list:
		if not CharacterList.has(true_name):
			unique_true_name_list.append(true_name)
	if unique_true_name_list.size() == 0:
		assert(false, "すべてのtrue_nameが使われています")
	var unique_true_name = unique_true_name_list[randi() % unique_true_name_list.size()]
	character.initialize({"true_name":unique_true_name})
	CharacterList[character.status["true_name"]]=character


func save_savedata(data:Dictionary):
	# ファイルを書き込みモードで開く.
	var f = FileAccess.open(STRUCT_CONST.save_data, FileAccess.WRITE)
	
	# "test save" という文字を書き込む.
	f.store_string(var_to_str(data))
	
	# ファイルを閉じる.
	f.close()
	infolog("save suceeded")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
