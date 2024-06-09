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
# キャラクターのステータスを保持する辞書
var status = {
	"NAME": "名無し",
	"GENDER": "male",
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
	},
	"FRD":{}, # 好感度
	"SKILLS": {},
	"PORTRAIT": "",
	"ITEMS": [],
	"ROLE": "",
	"TASKS": [],
	"LOG":[],
}
var role=null
var holiday_strategy=HolidayStrategy.WorkerHolic.new(self)

# ノードがシーンツリーに初めて入ったときに呼び出される
func _ready():
	pass # Replace with function body.

# AIが一日の行動を実行する
func act():
	pass

func die():
	World.infolog(status["NAME"]+"died!")

func damage(quantity:int, category:String="HP"):
	status[category] -= quantity
	if status[category] < 0:
		die()
	elif status[category] > get_ability(category):
		status[category] = get_ability(category)

func upgrade_ability(category:String="HP",quentity:float=0.01):
	status["ABILITY"][category] += quentity

func earn_money(earned_amount:int):
	"""
	キャラクターが金を稼ぐ関数
	"""
	status["MONEY"] += earned_amount

func get_ability(category:String):
	return int(status["ABILITY"][category])

func initialize(dict):
	"""
	辞書を引数に取り、キャラクターのステータスを初期化する関数
	"""
	for key in dict.keys():
		if key =="ROLE":
			role=World.role_classes[dict[key]].new(self)
		if not status.has(key):
			World.infolog("Warnig: " + str(key) + "はstatusに存在しません。")
		status[key] = dict[key]
	update_portrait()

func work():
	self.role.execute()

func excite():
	self.holiday_strategy.execute()

func add_to_log(text):
	"""
	テキストを引数に取り、ログに追加する関数。ログのサイズが30を超える場合、最初の要素を削除する。
	"""
	status["LOG"].append(text)
	if status["LOG"].size() > 30:
		status["LOG"].pop_front()

# statusの"PORTRAIT"が指定するパスの画像を読み込んで、Portraitノードのtextureを更新
func update_portrait():
	var portrait_path = status["PORTRAIT"]
	if portrait_path != "":
		var portrait_texture = load(portrait_path)
		get_node("Portrait").texture = portrait_texture
	else:
		var directory = DirAccess.open(World.constant.path.portrait)
		if directory:
			directory.list_dir_begin()
			var files = []
			var file_name = directory.get_next()
			while file_name != "":
				if directory.current_is_dir() or not file_name.get_extension() in World.constant.img_ext:
					file_name = directory.get_next()
					continue
				files.append(file_name)
				file_name = directory.get_next()
			if files.size() > 0:
				var random_file = files[randi() % files.size()]
				var portrait_texture = load(World.constant.path.portrait + random_file)
				get_node("Portrait").texture = portrait_texture
			else:
				print("Warning: ポートレートのフォルダに画像がありません。")
		else:
			print("Warning: ポートレートのパスが存在しません。")
