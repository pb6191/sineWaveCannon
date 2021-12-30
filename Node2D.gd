extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	 pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass




func _on_Button3_pressed():
	global.tries = global.tries - 1
	global.dict.thisSession[global.dict.thisSession.size()-1].trials.pop_back()
	global.closed = true
