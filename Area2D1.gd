extends Area2D

var velocity = Vector2(0, 0)
var normalPos = Vector2(100, 500)
var wind
var g
var totalDelta = 0
var sinValue
var currentVelocityAngle

func _process(delta):
	velocity.y += g * delta
	velocity.x += wind * delta
	normalPos += velocity * delta
	currentVelocityAngle = atan(velocity.y/velocity.x)
	sinValue = int(80*sin(totalDelta*5))
	position.x = normalPos.x  - sinValue * sin(currentVelocityAngle*1)
	position.y = normalPos.y  + sinValue * cos(currentVelocityAngle*1)
	rotation = velocity.angle()
	totalDelta = totalDelta + delta

