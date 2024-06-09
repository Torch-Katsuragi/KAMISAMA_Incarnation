extends Object
class_name HolidayStrategy

class Interface extends Role.Interface:
	pass

class WorkerHolic extends Interface:
	func _init(chara):
		super._init(chara)

	func execute():
		if character.status["HP"]>character.status["ABILITY"]["HP"]*0.5:
			World.add_event(Event.DungeonCrowl.new(self.character))
		else:
			World.add_event(Event.Rest.new(self.character))