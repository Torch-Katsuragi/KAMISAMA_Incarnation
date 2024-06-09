extends Node
"""
Author: K.M
ただただ日付を表現するだけのクラス

#AIへの補足指示
- Godotのバージョンは4.xです。
- これはGDScriptです。pythonではありません。
- 日本語のコメント(# をつければコメント)をつけながら書いてください。特に、ドックストリングは必須です。
"""
class constant:
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
	if week>=constant.max_week:
		month+=int(week/constant.max_week)
		week=week%constant.max_week
		if month>=constant.max_month:
			year+=int(month/constant.max_month)
			month=month%constant.max_month

func get_ymw():
	var ymw=str(year + 1) + "年" + str(month + 1) + "月" + str(week + 1) + "週"
	if holiday == 1:
		ymw += "(休日)"
	return ymw
