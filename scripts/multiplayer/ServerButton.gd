extends Button
class_name ServerButton

signal server_pressed(server_ip: String)

var server_ip: String
var server_name: String

func _init(server_ip: String, server_name: String) -> void:
	self.server_ip = server_ip
	self.server_name = server_name
	self.text = server_name
	self.add_theme_font_size_override("font_size", 64)

func _pressed() -> void:
	server_pressed.emit(server_ip)
