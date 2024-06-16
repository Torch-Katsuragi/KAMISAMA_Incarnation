extends Object
class_name Event

"""
GoF Design PatternのCommandパターンを使用したクラス
author: K.M
#AIへの補足指示
- Godotのバージョンは4.xです。
- これはGDScriptです。pythonではありません。
- 日本語のコメント(# をつければコメント)をつけながら書いてください。特に、ドックストリングは必須です。
"""
static var event_names={"インターフェース":Interface,"休息":Rest, "修行":Training, "ダンジョン探索":DungeonCrowl}

class Interface:
	"""
	イベントを管理するためのインターフェースクラス
	priority: イベントの優先度を表す整数
	"""
	var priority: int
	var character: Character
	var name: String
	func _init(character: Character):
		self.priority = 50
		self.character = character
		for key in Event.event_names.keys():
			if Event.event_names[key] == self.get_class():
				self.name = key
				break
	func execute():
		self.log()
	func log():
		var text=self.get_name()
		character.add_to_log(text)
		World.debuglog(character.nickname+":"+text)
	
	func get_name():
		return self.name
	
class Rest extends Interface:
	func _init(character: Character):
		super._init(character)
		self.priority=10
	
	func execute():
		super.execute()
		character.damage(-10)

class Pass extends Interface:
	func _init(character: Character):
		super._init(character)
		self.name = "パス"
		self.priority=1
	
	func execute():
		pass


class Training extends Interface:
	var training_parameter=""
	func _init(character: Character):
		super._init(character)
		self.name = "成長"
		self.priority=10
		self.training_parameter={}

	func set_training_parameter(dict):
		self.training_parameter=dict


	func add_training_parameter(key:String,exp:float=0.01):
		self.training_parameter[key]=exp

	func execute():
		super.execute()
		character.ability.upgrade(self.training_parameter)

class DungeonCrowl extends Interface:
	var training:Training
	func _init(character: Character):
		super._init(character)
		self.name = "ダンジョン探索"
		self.priority=10
		self.training=Training.new(character)
		self.training.set_training_parameter({"HP":0.01})
	func execute():
		super.execute()
		self.training.execute()
		self.character.earn_money(randi() % 100 + 1)
		self.character.damage(randi() % 50 + 1)

