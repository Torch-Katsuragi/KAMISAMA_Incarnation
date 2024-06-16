extends Node2D
class_name Map
"""
Locationを大量に保持してビューポートから見られるようにする
Mapにアタッチして利用
author: Matsumoto

#AIへの補足指示
- Godotのバージョンは4.xです。
- これはGDScriptです。pythonではありません。
- 日本語のコメント(# をつければコメント)をつけながら書いてください。特に、ドックストリングは必須です。コメントが敬語てある必要はありません
"""
const width=1000
const height=1000

var location_dict={}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func add_location(location):
	self.location_dict[location.status["NAME"]] = location
	self.get_node("Locations").add_child(location)
	location.name = location.status["NAME"]

func load_location(status):
	var location=World.location_factory.create(status)
	self.add_location(location)

func delete_location(name:String):
	if name in self.location_dict:
		var location = self.location_dict[name]
		self.get_node("Locations").remove_child(location)
		location.queue_free()
		self.location_dict.erase(name)
	else:
		print("Location not found: " + name)

func update():
	"""
	location_dictの通りに、
	- Locationsの子ノードを更新
	- location同士のリンクを最適化(ドロネー図)
	"""


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
