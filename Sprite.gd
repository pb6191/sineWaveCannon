extends Sprite

const Area2D1 = preload("res://Area2D1.tscn")
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var g1
var wind1
var rng = RandomNumberGenerator.new()
var rng2 = RandomNumberGenerator.new()
var flipFlop
var dispText = ""
var timeS
var time_returnS


# Called when the node enters the scene tree for the first time.
func _ready():
	timeS = OS.get_time()
	time_returnS = String(timeS.hour) +":"+String(timeS.minute)+":"+String(timeS.second)
	$"../RichTextLabel2".text = "Score: "+str(global.currentScore)+"\nTries: "+str(global.tries)
	$"TextureProgress".value = muzzle_velocity
	$"TextureProgress".max_value = 10*muzzleK
	if global.g == 0:
		g1 = 100.0
	elif global.g == 1:
		rng.randomize()
		g1 = float(rng.randi_range(0, 200))
	elif global.g == 2:
		rng.randomize()
		g1 = float(rng.randi_range(-200, 0))
	else:
		rng.randomize()
		g1 = float(rng.randi_range(-200, 200))
	if global.w == 1:
		wind1 = 100.0
	elif global.w == 4:
		rng2.randomize()
		wind1 = float(rng.randi_range(0, 200))
	elif global.w == 2:
		rng2.randomize()
		wind1 = float(rng.randi_range(-200, 0))
	elif global.w == 0:
		wind1 = 0.0
	else:
		rng2.randomize()
		wind1 = float(rng.randi_range(-200, 200))
	if global.gInd == 1:
		dispText = dispText + "Gravity: "+str(g1)
	if global.wInd == 1:
		dispText = dispText + "    Wind: "+str(wind1)
	$"../RichTextLabel".text = dispText
	$"../Sprite3".material.set_shader_param("strengthScale", wind1)
	$"../Sprite3".material.set_shader_param("direction", wind1)
	$"../Sprite3".material.set_shader_param("speed", wind1/10)
	$"../Sprite4".material.set_shader_param("strengthScale", g1)
	$"../Sprite4".material.set_shader_param("direction", 1.0)
	$"../Sprite4".material.set_shader_param("speed", g1/10)
	if g1 > 0.0:
		$"../Sprite4".scale.y = 0.3
	else:
		$"../Sprite4".scale.y = -0.3
	if global.gInd == 0:
		$"../Sprite4".visible = false
	if global.wInd == 0:
		$"../Sprite3".visible = false


var muzzleK = 100.0 * 4
var muzzle_velocity = muzzleK
#export var gravity = 250.0


func shoot():
	var b = Area2D1.instance()
	owner.add_child(b)
	$Barrel.rotation = get_angle_to(get_global_mouse_position())
	b.transform = $Barrel.global_transform
	b.velocity = b.transform.x * muzzle_velocity
	#forcing 45 angle and velocity
	b.velocity = Vector2(200, -200)
	b.g = g1
	b.wind = wind1
	global.dict.thisSession[global.dict.thisSession.size()-1].trials[global.dict.thisSession[global.dict.thisSession.size()-1].trials.size()-1].angle = $Barrel.rotation
	global.dict.thisSession[global.dict.thisSession.size()-1].trials[global.dict.thisSession[global.dict.thisSession.size()-1].trials.size()-1].forceDuration = muzzle_velocity

var mousePressDur = 0.0
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if flipFlop == "flip":
		mousePressDur = mousePressDur + delta
		muzzle_velocity = min(10*muzzleK, mousePressDur*3*muzzleK+muzzleK)
		$"TextureProgress".value = muzzle_velocity
	$"TextureProgress".rect_rotation = rad2deg(get_angle_to(get_global_mouse_position()))

func _input(event):
	if (event.is_action_pressed("leftClk") or (event is InputEventScreenTouch and event.pressed == true)) and get_tree().current_scene == $"..":
		var time2 = OS.get_time()
		var time_return2 = String(time2.hour) +":"+String(time2.minute)+":"+String(time2.second)
		global.dict.thisSession[global.dict.thisSession.size()-1].trials.append(global.dict.thisSession[global.dict.thisSession.size()-1].duplicate(true).trials[0])
		global.dict.thisSession[global.dict.thisSession.size()-1].trials[global.dict.thisSession[global.dict.thisSession.size()-1].trials.size()-1].timeStart = time_returnS
		global.dict.thisSession[global.dict.thisSession.size()-1].trials[global.dict.thisSession[global.dict.thisSession.size()-1].trials.size()-1].timePress = time_return2
		global.dict.thisSession[global.dict.thisSession.size()-1].trials[global.dict.thisSession[global.dict.thisSession.size()-1].trials.size()-1].gravityVal = g1
		global.dict.thisSession[global.dict.thisSession.size()-1].trials[global.dict.thisSession[global.dict.thisSession.size()-1].trials.size()-1].windVal = wind1
		mousePressDur = 0.0
		flipFlop = "flip"
	if event is InputEventMouseMotion:
		$"../Sprite2".position = event.position
		if event.position.x < 900:
			$"../Sprite2".position.x = 900
	if event.is_action_pressed("ui_up"):
		$"../Sprite2".scale.x += 0.1 * $"../Sprite2".scale.x
		$"../Sprite2".scale.y += 0.1 * $"../Sprite2".scale.y
	if event.is_action_pressed("ui_down"):
		$"../Sprite2".scale.x -= 0.1 * $"../Sprite2".scale.x
		$"../Sprite2".scale.y -= 0.1 * $"../Sprite2".scale.y
		
	if (event.is_action_released("leftClk") or (event is InputEventScreenTouch and event.pressed == false)) and get_tree().current_scene == $".." and flipFlop == "flip":
		var time2 = OS.get_time()
		var time_return2 = String(time2.hour) +":"+String(time2.minute)+":"+String(time2.second)
		global.dict.thisSession[global.dict.thisSession.size()-1].trials[global.dict.thisSession[global.dict.thisSession.size()-1].trials.size()-1].timeRelease = time_return2
		shoot()
		global.tries = global.tries + 1
		$"../RichTextLabel2".text = "Score: "+str(global.currentScore)+"\nTries: "+str(global.tries)
		muzzle_velocity = muzzleK
		mousePressDur = 0.0
		$"TextureProgress".value = muzzle_velocity
		flipFlop = "flop"



func _on_Area2D_area_entered(area):
	global.dict.thisSession[global.dict.thisSession.size()-1].trials[global.dict.thisSession[global.dict.thisSession.size()-1].trials.size()-1].success = "true"
	global.currentScore = global.currentScore + 100
	$"../RichTextLabel2".text = "Score: "+str(global.currentScore)+"\nTries: "+str(global.tries)
	$"../RichTextLabel3".visible = true
	yield(get_tree().create_timer(1.0), "timeout")
	get_tree().reload_current_scene()

