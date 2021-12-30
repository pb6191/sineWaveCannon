extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var g
var w
var gInd
var wInd
var score
var currentScore = 0
var tries = 0
var dict = {"thisSession": [{"gravityInd": "", "windInd": "", "gravity": "", "wind": "", "trials": [{"timeStart": "", "timePress": "", "timeRelease": "", "gravityVal": "", "windVal": "", "angle": "", "forceDuration": "", "success": "false"}]}]}
var rng3 = RandomNumberGenerator.new()
var dataString = {"filename": "", "filedata":""}
var http_client
var connErr
var closed = false

# Called when the node enters the scene tree for the first time.
func _ready():
	http_client = HTTPClient.new()
	connErr = http_client.connect_to_host("192.168.0.10", 8081)
	#while(http_client.get_status() != 5):
	#	http_client.poll()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if closed == true:
		dataString.filename = "dataFile_"+makeid(16)+".json"
		dataString.filedata = JSON.print(dict)
		var outputCode = _make_post_request("/CannonHTML2/record_result.php", dataString)
		get_tree().change_scene("res://CloseScn.tscn")

func makeid(length):
	var result           = ''
	var characters       = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789'
	var charactersLength = characters.length() - 1
	for i in length:
		rng3.randomize()
		result += characters[rng3.randi_range(0, charactersLength)]
	return result


func _make_post_request(url, data_to_send):
	# Convert data to json string:
	var query = JSON.print(data_to_send)
	# Add 'Content-Type' header:
	var headers = ["Content-Type: application/json"]
	http_client.poll()
	print(query)
	var returnVal = http_client.request(HTTPClient.METHOD_POST, url, headers, query)
	http_client.close()
	return returnVal
	
#func _notification(what):
#	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST or what == MainLoop.NOTIFICATION_WM_GO_BACK_REQUEST:
#		dataString.filename = "dataFile_"+makeid(16)+".json"
#		dataString.filedata = JSON.print(dict)
#		var outputCode = _make_post_request("/CannonHTML2/record_result.php", dataString)
