extends Control 
class_name ServerButton

signal server_pressed(server_ip: String)

@onready var server_button: Button = $Button

var server_ip: String
var server_name: String

func init(ip: String, host_name: String) -> void:
	self.server_ip = ip
	self.server_name = host_name

func _ready() -> void:
	if server_button:
		server_button.text = server_name

func _on_button_pressed() -> void:
	server_pressed.emit(server_ip)
