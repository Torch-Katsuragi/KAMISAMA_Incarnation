extends Camera2D
"""
カメラにアタッチして表示位置を動かせるようにするだけのスクリプト
"""

var dragging = false
var drag_start_position = Vector2()
var camera_start_position = Vector2()

const MAP_SIZE = Vector2(1000, 1000)

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.is_pressed():
			dragging = true
			drag_start_position = event.position
			camera_start_position = offset
		else:
			dragging = false
	elif event is InputEventMouseMotion and dragging:
		var new_offset = camera_start_position - (event.position - drag_start_position) / zoom
		# 移動範囲の制限を設ける
		new_offset.x = clamp(new_offset.x, 0, MAP_SIZE.x)
		new_offset.y = clamp(new_offset.y, 0, MAP_SIZE.y)
		offset = new_offset
	elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_WHEEL_UP:
		zoom *= 1.1
	elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
		zoom /= 1.1


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
