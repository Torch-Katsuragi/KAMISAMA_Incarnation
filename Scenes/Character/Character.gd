"""
キャラクターシーンにアタッチして振舞いを定義
author: K.M
#AIへの補足指示
- Godotのバージョンは4.xです。
- これはGDScriptです。pythonではありません。
- 日本語のコメント(# をつければコメント)をつけながら書いてください。特に、ドックストリングは必須です。
"""

extends Node2D
class_name Character



# キャラの能力値管理クラス
class Ability:
	var hp=0
	var mp=0
	var power=0
	var intelligence=0
	var dexterity=0
	var agility=0
	var charisma=0
	var skills={}

	func _init(dict:Dictionary):
		# 辞書からプロパティに代入
		for key in dict.keys():
			self.update_ability(key,dict[key])
		
	# 辞書のkeyとvalueを引数にとって、適切な変数に割り当てるメソッド
	func update_ability(key: String, value):
		match key:
			"HP":
				self.hp += value
			"MP":
				self.mp += value
			"POW":
				self.power += value
			"INT":
				self.intelligence += value
			"DEX":
				self.dexterity += value
			"AGI":
				self.agility += value
			"CHA":
				self.charisma += value
			"SKILLS":
				for skill in value.keys():
					if skill in self.skills:
						self.skills[skill] += value[skill]
					else:
						self.skills[skill] = value[skill]

	func upgrade(dict={"HP":0.01}):
		if "SKILLS" in dict.keys():
			for skill in dict["SKILLS"]:
				if skill in self.skills:
					self.skills[skill] += dict["SKILLS"][skill]
				else:
					self.skills[skill] = dict["SKILLS"][skill]
			dict.erase("SKILLS")
		for key in dict.keys():
			self.update_ability(key,dict[key])

	func get_dict() -> Dictionary:
		"""
		_initとは逆に、現在のアビリティを辞書として返す
		"""
		var dict = {
			"HP": self.hp,
			"MP": self.mp,
			"POW": self.power,
			"INT": self.intelligence,
			"DEX": self.dexterity,
			"AGI": self.agility,
			"CHA": self.charisma,
			"SKILLS": self.skills.duplicate()
		}
		return dict


var nickname: String = ""
var true_name: String = ""
var gender: int = 0
var hp: int = 100
var mp: int = 100
var money: int = 0
var ability: Ability = Ability.new({
		"HP": 100,
		"MP": 100,
		"POW": 10,
		"INT": 10,
		"DEX": 10,
		"AGI": 10,
		"CHA": 10,
		"SKILLS": {},
	})
var friendship: Dictionary = {}
var inventory: Dictionary = {}
var role: Role.Interface = Role.Adventurer.new(self)
var current_action: Object = null
var event_log: Array = []
var holiday_strategy: HolidayStrategy.WorkerHolic = HolidayStrategy.WorkerHolic.new(self)
var portrait_path: String = ""
var current_location:Location


# ノードがシーンツリーに初めて入ったときに呼び出される
func _ready():
	pass # Replace with function body.

# AIが一日の行動を実行する
func act():
	pass

func die():
	World.infolog(self.true_name+"died!")

func damage(quantity:int):
	self.hp -= quantity
	if self.hp < 0:
		die()
	elif self.ability.hp > self.hp:
		self.ability.hp = self.hp

func earn_money(amount:int):
	self.money+=amount

func initialize(dict):
	"""
	辞書を引数に取り、キャラクターのステータスを初期化する関数
	"""
	self.add_to_group("Alive")
	# ロケーションが間違っていても、最悪ランダムな位置に飛ばせばOK!
	var location_keys = World.map.location_dict.keys()
	self.current_location = World.map.location_dict[location_keys[randi() % location_keys.size()]]
	for key in dict.keys():
		match key:
			"NAME":
				self.nickname = dict[key]
			"GENDER":
				self.gender = dict[key]
			"TRUE_NAME":
				self.true_name = dict[key]
			"HP":
				self.hp = dict[key]
			"MP":
				self.mp = dict[key]
			"MONEY":
				self.money = dict[key]
			"ABILITY":
				self.ability = Ability.new(dict[key])
			"FRD":
				self.friendship = dict[key]
			"PORTRAIT":
				self.portrait_path = dict[key]
			"ITEMS":
				self.inventory=dict[key]
			"ROLE":
				self.role = Role.Adventurer.new(self) # ここは適切なRoleの初期化に変更する必要があるかもしれません
			"LOG":
				self.event_log = dict[key]
			"LOCATION":
				if dict[key] in World.map.location_dict:
					self.current_location = World.map.location_dict[dict[key]]
	update_portrait()

func get_dict()->Dictionary:
	"""
	セーブなどのために、キャラクターインスタンスを復元するための辞書を生成
	"""
	var status = {
		"NAME": self.nickname,
		"GENDER": self.gender,
		"TRUE_NAME": self.true_name,
		"HP": self.hp,
		"MP": self.mp,
		"MONEY": self.money,
		"ABILITY": {
			"HP": self.ability.hp,
			"MP": self.ability.mp,
			"POW": self.ability.power,
			"INT": self.ability.intelligence,
			"DEX": self.ability.dexterity,
			"AGI": self.ability.agility,
			"CHA": self.ability.charisma,
			"SKILLS": self.ability.skills,
		},
		"FRD": self.friendship, # 好感度
		"PORTRAIT": self.portrait_path,
		# "ITEMS": self.inventory.keys(),
		"ITEMS": self.inventory,
		"ROLE": self.role.name,
		"TASK": "",
		"LOG": self.event_log,
	}
	return status




func work():
	self.role.execute()

func excite():
	self.holiday_strategy.execute()

func add_to_log(text):
	"""
	テキストを引数に取り、ログに追加する関数。ログのサイズが30を超える場合、最初の要素を削除する。
	"""
	self.event_log.append(text)
	if self.event_log.size() > 30:
		self.event_log.pop_front()

# statusの"PORTRAIT"が指定するパスの画像を読み込んで、Portraitノードのtextureを更新
func update_portrait():
	if portrait_path != "":
		var portrait_texture = load(portrait_path)
		get_node("Portrait").texture = portrait_texture
	else:
		var directory = DirAccess.open(World.path.character.portrait)
		if directory:
			directory.list_dir_begin()
			var files = []
			var file_name = directory.get_next()
			while file_name != "":
				if directory.current_is_dir() or not file_name.get_extension() in World.img_ext:
					file_name = directory.get_next()
					continue
				files.append(file_name)
				file_name = directory.get_next()
			if files.size() > 0:
				var random_file = files[randi() % files.size()]
				var portrait_texture = load(World.path.character.portrait + random_file)
				get_node("Portrait").texture = portrait_texture
			else:
				print("Warning: ポートレートのフォルダに画像がありません。")
		else:
			print("Warning: ポートレートのパスが存在しません。")
