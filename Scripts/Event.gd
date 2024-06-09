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
var event_names={"休息":Rest, "修行":Training, "ダンジョン探索":DungeonCrowl}

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
	func execute():
		self.log()
	func log():
		var text=self.get_name()
		character.add_to_log(text)
		World.debuglog(character.status["NAME"]+":"+text)
    
	func get_name():
		return self.name
	
class Rest extends Interface:
	func _init(character: Character):
		super._init(character)
		self.name = "休息"
		self.priority=10
	
	func execute():
		super.execute()
		character.damage(-10, "HP")
		character.damage(-10, "MP")

class Training extends Interface:
	func _init(character: Character):
		super._init(character)
		self.name = "修行"
		self.priority=10
	
	func execute():
		super.execute()
		var abilities = character.status["ABILITY"].keys()
		var random_ability = abilities[randi() % abilities.size()]
		character.upgrade_ability(random_ability, 0.1)

class DungeonCrowl extends Interface:
	func _init(character: Character):
		super._init(character)
		self.name = "ダンジョン探索"
		self.priority=10
	func execute():
		super.execute()
		var abilities = character.status["ABILITY"].keys()
		var random_ability = abilities[randi() % abilities.size()]
		character.upgrade_ability(random_ability, 0.1)
		self.character.earn_money(randi() % 100 + 1)
		self.character.damage(randi() % 50 + 1)

