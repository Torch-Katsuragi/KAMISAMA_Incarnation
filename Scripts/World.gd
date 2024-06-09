extends Node
"""
Author: K.M
ノードにはアタッチせず、自動読み込みで利用するスクリプト
プロジェクト全体を管理する処理をいろいろ書いていく。AIの参照先を増やすのが面倒なので、できるだけこのファイルで完結させたい

#AIへの補足指示
- Godotのバージョンは4.xです。
- これはGDScriptです。pythonではありません。
- 日本語のコメント(# をつければコメント)をつけながら書いてください。特に、ドックストリングは必須です。
"""

# 定数をひとまとめに構造体で保存。こうすると予測変換がめっちゃ早くて楽
class constant:
	class path:
		# const WORKING_DIR="user://"
		const working_dir = "res://Gamedata/"
		const save_data = working_dir + "SaveData.txt"
		const name="res://Gamedata/Names.txt"
		const true_name ="res://Gamedata/Truenames.txt"
		const portrait = "res://Assets/Images/Portraits/"
	# 0: all, 1: debug and info, 2: info only
	const debug_level = 0
	const img_ext = ["png", "jpg", "jpeg"]
	class scene:
		const character = preload ("res://Character/Character.tscn")
	
# logging.debugの代わり
func debuglog(text):
	if constant.debug_level < 2:
		print("DEBUG: " + text)

# logging.infoの代わり
func infolog(text):
	if constant.debug_level < 3:
		print("INFO: " + text)

var true_name_list = ["エレフローゼ", "アレスティオール"]
var name_list=["リリア"]
var character_dict = {}
var event_queue=[]
var role_classes={"冒険者":Role.Adventurer}

# factory系列
var character_factory=Factory.CharacterFactory.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	true_name_list=str_to_var(read_file(constant.path.true_name))
	name_list=str_to_var(read_file(constant.path.name))

	load_savedata()
	for i in range(5):
		var character= character_factory.born()
		character_dict[character.status["TRUE_NAME"]] = character

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

func load_savedata():
	var text = read_file(constant.path.save_data)

	var savedata=str_to_var(text)

	if "character_dict" in savedata:
		for character_name in savedata["character_dict"].keys():
			var status=savedata["character_dict"][character_name]
			var character = character_factory.create(status)
			character_dict[character.status["TRUE_NAME"]] = character
	else:
		infolog("character_dictがセーブデータに存在しません")

func add_event(event:Event.Interface):
	event_queue.append(event)

func save_savedata(data: Dictionary):
	# ファイルを書き込みモードで開く.
	var f = FileAccess.open(constant.path.save_data, FileAccess.WRITE)
	
	# "test save" という文字を書き込む.
	f.store_string(var_to_str(data))
	
	# ファイルを閉じる.
	f.close()
	infolog("save suceeded")

func execute():
	if Calender.holiday==0:
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
	Calender.tick()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
