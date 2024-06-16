extends Node
"""
Author: K.M
ノードにはアタッチせず、自動読み込みで利用するスクリプト
プロジェクト全体を管理する処理をいろいろ書いていく。AIの参照先を増やすのが面倒なので、できるだけこのファイルで完結させたい

#AIへの補足指示
- Godotのバージョンは4.xです。
- これはGDScriptです。pythonではありません。
- 日本語のコメント(# をつければコメント)をつけながら書いてください。特に、ドックストリングは必須です。コメントが敬語てある必要はありません
"""

# 定数をひとまとめに構造体で保存。こうすると予測変換がめっちゃ早くて楽
class path:
	# const WORKING_DIR="user://"
	const working_dir = "res://Gamedata/"
	const save_data = working_dir + "SaveData.txt"
	class character:
		const name="res://Gamedata/Names.txt"
		const true_name ="res://Gamedata/Truenames.txt"
		const portrait = "res://Assets/Images/Portraits/"
	class location:
		const name="res://GameData/LocationNames.txt"
# 0: all, 1: debug and info, 2: info only
const debug_level = 0
const img_ext = ["png", "jpg", "jpeg"]
class scene:
	const character = preload ("res://Scenes/Character/Character.tscn")
	const location=preload("res://Scenes/Map/Location.tscn")
	const map=preload("res://Scenes/Map/Map.tscn")

# logging.debugの代わり
func debuglog(text):
	if debug_level < 2:
		print("DEBUG: " + text)

# logging.infoの代わり
func infolog(text):
	if debug_level < 3:
		print("INFO: " + text)

func read_file(path:String):
	if FileAccess.file_exists(path) == false:
		infolog("存在しません: %s" %path)
		return ""
	var f = FileAccess.open(path, FileAccess.READ)
	var text=f.get_as_text()
	debuglog(text)
	
	# ファイルを閉じる.
	f.close()
	return text

func write_file(path:String,text:String):
	# ファイルを書き込みモードで開く.
	var f = FileAccess.open(path, FileAccess.WRITE)
	debuglog(text)
	# "test save" という文字を書き込む.
	f.store_string(text)
	
	# ファイルを閉じる.
	f.close()

# ただただ日付を表現するだけのクラス
class Calender:
	const max_month=12
	const max_week=4

	var year=0
	var month=0
	var week=0
	var holiday=0 # 0: オンウィーク、1: 休日

	func tick():
		"""時間を1単位進める"""
		if holiday==0:
			holiday=1
		else:
			holiday=0
			past_week(1)

	func past_week(weeks:int):
		week+=weeks
		if week>=max_week:
			month+=int(week/max_week)
			week=week%max_week
			if month>=max_month:
				year+=int(month/max_month)
				month=month%max_month

	func get_ymw():
		var ymw=str(year + 1) + "年" + str(month + 1) + "月" + str(week + 1) + "週"
		if holiday == 1:
			ymw += "(休日)"
		return ymw


var calender=Calender.new()
var character_dict = {}
var event_queue=[]
var role_classes={"冒険者":Role.Adventurer}
var map=scene.map.instantiate()

# factory系列
var character_factory
var location_factory

# Called when the node enters the scene tree for the first time.
func _ready():
	self.character_factory=Factory.CharacterFactory.new()
	self.location_factory=Factory.LocationFactory.new()

	if not map.location_dict:
		for i in range(5):
			map.add_location(location_factory.born())
	load_savedata()
	
	if not character_dict:
		for i in range(5):
			var character= character_factory.born()
			character_dict[character.true_name] = character
	


func load_savedata():
	var text = read_file(path.save_data)

	var savedata=str_to_var(text)
	if typeof(savedata) != TYPE_DICTIONARY:
		infolog("エラー: セーブデータが辞書型ではありません")
		return

	if "character_dict" in savedata:
		for character_name in savedata["character_dict"].keys():
			var status=savedata["character_dict"][character_name]
			var character = character_factory.create(status)
			character_dict[character.true_name] = character
	else:
		infolog("character_dictがセーブデータに存在しません")

func add_event(event:Event.Interface):
	event_queue.append(event)

func save_savedata():
	debuglog("save start")
	var data={}
	
	data["character_dict"]={}
	for character in character_dict.values():
		data["character_dict"][character.true_name]=character.get_dict()
	var text=var_to_str(data)
	write_file(path.save_data,text)

	infolog("save suceeded")

func execute():
	if calender.holiday==0:
		# 休日じゃないので働く！
		for character in character_dict.values():
			character.work()
	else:
		# 休日です！おめでとうございます！
		for character in character_dict.values():
			character.excite()
	
	while event_queue.size() > 0:
		var event = event_queue.pop_front()
		event.execute()
	calender.tick()
