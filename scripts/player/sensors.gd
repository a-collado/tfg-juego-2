extends Node

var JavaScript = JavaScriptBridge
var has_feature_web: bool

func _init():
	
	if not OS.has_feature('web'): 
		has_feature_web = false
		return

	has_feature_web = true
	JavaScript.eval(
	"""
		var acceleration = { x: 0, y: 0, z: 0 }

		function handleMotionEvent(event) {
			if (event.accelerationIncludingGravity.x === null) return
			acceleration.x = event.accelerationIncludingGravity.x;
			acceleration.y = event.accelerationIncludingGravity.y;
			acceleration.z = event.accelerationIncludingGravity.z;
		}

		window.addEventListener("devicemotion", handleMotionEvent, true);
	""", true)

func get_accelerometer() -> Vector3:
	if not has_feature_web: return Input.get_gravity()
	
	var x = JavaScript.eval('acceleration.x')
	var y = JavaScript.eval('acceleration.y')
	var z = JavaScript.eval('acceleration.z')
	return Vector3(x, y, z)
