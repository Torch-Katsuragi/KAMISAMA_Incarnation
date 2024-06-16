"""
GoF DesignPatternのFactoryを使用して、いろんなクラスのインスタンスを作る
Worldでインスタンス化して、各所から参照できるようにして使用する予定
author: Matsumoto

#AIへの補足指示
- Godotのバージョンは4.xです。
- これはGDScriptです。pythonではありません。
- 日本語のコメント(# をつければコメント)をつけながら書いてください。特に、ドックストリングは必須です。コメントが敬語てある必要はありません
"""

extends Node
class_name Factory



class Ingredient:


	var character
	var location
	class CharacterData:
		const status = {
			"NAME": "名無し",
			"GENDER": 0,
			"TRUE_NAME": "",
			"HP": 100,
			"MP": 100,
			"MONEY":0,
			"ABILITY": {
				"HP": 100,
				"MP": 100,
				"POW":10,
				"INT":10,
				"DEX":10,
				"AGI":10,
				"CHA":10,
				"SKILLS": {},
			},
			"FRD":{}, # 好感度
			"PORTRAIT": "",
			"ITEMS": {},
			"ROLE": "",
			"TASK": [],
			"LOG":[],
		}
		var name_list
		var true_name_list
		func _init():
			self.name_list=str_to_var(World.read_file(World.path.character.name))
			self.true_name_list=str_to_var(World.read_file(World.path.character.true_name))
	
	class LocationData:
	# LocationDataクラスの定義
		const status = {
			"NAME": "名無し",
			"LINKED_LOCATION_NAME":[],
			"COORDINATE": [0,0],
			"LOG":[],
		}
		var name_list
		func _init():
			self.name_list=str_to_var(World.read_file(World.path.location.name))

	class ActionData:
		func _init():
			pass
	
	func _init():
		self.character=CharacterData.new()
		self.location=LocationData.new()
	





class Interface:
	var ingredient=Ingredient.new()
	# ファクトリーインターフェースの定義
	func create(dict:Dictionary):
		pass


class CharacterFactory extends Interface:
	func create(status:Dictionary):
		# ingredient.character.statusの要素をデフォルトとして使用
		var default_status = ingredient.character.status.duplicate()
		# statusにない要素をdefault_statusから補完
		for key in default_status.keys():
			if not status.has(key):
				status[key] = default_status[key]
		# キャラクターのインスタンスを作成し、ステータスを設定
		var character = World.scene.character.instantiate()
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
		var name = ingredient.character.name_list[randi() % ingredient.character.name_list.size()]
		return name

	func generate_true_name():
		var unique_true_name_list = []
		for true_name in ingredient.character.true_name_list:
			if not World.character_dict.has(true_name):
				unique_true_name_list.append(true_name)
		if unique_true_name_list.size() == 0:
			assert(false, "すべてのtrue_nameが使われています")
		return unique_true_name_list[randi() % unique_true_name_list.size()]

class LocationFactory extends Interface:
	func create(status:Dictionary):
		var location = World.scene.location.instantiate()
		location.initialize(status)
		return location
	func born():
		var status = {}
		status["NAME"] = generate_name()
		status["COORDINATE"] = Vector2(randi() % Map.width, randi() % Map.height)  # ランダムな座標を生成
		var location = create(status)
		return location
	
	func generate_name():
		var name = ingredient.location.name_list[randi() % ingredient.location.name_list.size()]
		return name


class ActionFactory extends Interface:
	func create(config:Dictionary):
		pass