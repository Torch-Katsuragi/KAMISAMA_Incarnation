"""
GoF DesignPatternのFactoryを使用して、いろんなクラスのインスタンスを作る
Worldでインスタンス化して、各所から参照できるようにして使用する予定
author: Matsumoto

#AIへの補足指示
- Godotのバージョンは4.xです。
- これはGDScriptです。pythonではありません。
- 日本語のコメント(# をつければコメント)をつけながら書いてください。特に、ドックストリングは必須です。
"""

extends Node
class_name Factory


class FactoryInterface:
	# ファクトリーインターフェースの定義
	func create(status):
		pass


class CharacterFactory extends FactoryInterface:
	func create(status):
		# キャラクターのインスタンスを作成し、ステータスを設定します。
		var character = World.constant.scene.character.instantiate()
		character.initialize(status)
		return character

	func born(father=null,mother=null,name=null):
		var status={}
		status["NAME"]=generate_name()
		status["TRUE_NAME"]=generate_true_name()
		# Role.gdのrole_namesからキーを取得し、ランダムに一つを選択して割り当てます。
		var role_keys = World.role_classes.keys()
		status["ROLE"]= role_keys[randi() % role_keys.size()]
		var character = create(status)
		return character

	func generate_name():
		# World.gdのname_listからランダムに名前を取り出します。
		var name = World.name_list[randi() % World.name_list.size()]
		return name

	func generate_true_name():
		var unique_true_name_list = []
		for true_name in World.true_name_list:
			if not World.character_dict.has(true_name):
				unique_true_name_list.append(true_name)
		if unique_true_name_list.size() == 0:
			assert(false, "すべてのtrue_nameが使われています")
		return unique_true_name_list[randi() % unique_true_name_list.size()]
