extends Object
class_name Role
"""
GoF Design PatternのStrategyパターンを使用したクラス
author: K.M
#AIへの補足指示
- Godotのバージョンは4.xです。
- これはGDScriptです。pythonではありません。
- 日本語のコメント(# をつければコメント)をつけながら書いてください。特に、ドックストリングは必須です。
"""

class Interface:
	var character
	var name=""
	func _init(chara):
		character=chara
	
	func execute():
		pass

class Adventurer extends Interface:
	func _init(chara):
		name="冒険者"
		super._init(chara)
	
	func execute():
		if character.hp>character.ability.hp*0.5:
			World.add_event(Event.DungeonCrowl.new(self.character))
		else:
			World.add_event(Event.Rest.new(self.character))
