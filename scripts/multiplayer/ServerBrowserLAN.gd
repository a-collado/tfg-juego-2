extends Control

signal server_found(server_ip: String, player_name: String)

@onready var broadcastTimer: Timer = $BroadcastTimer
@onready var timeoutTimer: Timer = $TimeoutTimer

const LISTEN_PORT = 7001
const BROADCAST_PORT = 7002
# Esta es la direccion de multicast valida con mi configuracion de red actual.
# Podria ser diferente en otras redes: 255.255.255.255 deberia valer para todas.
const BROADCAST_ADDRESS = "192.168.1.255"
#const BROADCAST_ADDRESS = "255.255.255.255"

var room_info: Dictionary = {"name": "Name", "count": 0}
# Manually send UDP Packets
var broadcaster: PacketPeerUDP
var listener: PacketPeerUDP

var server_list: PackedStringArray

func _process(_delta: float) -> void:
	if listener == null || listener.get_available_packet_count() <= 0:
		return
	var server_ip = listener.get_packet_ip()
	var server_port = listener.get_packet_port()
	var server_packet = listener.get_packet()
	var packet_data = server_packet.get_string_from_ascii()
	var tmp_server_info = packet_data.split("\n")
	var server_info = {"name": tmp_server_info[0], "count": int(tmp_server_info[1])}

	print("Server detected at IP: " + str(server_ip) + " PORT: " + str(server_port)
	+ " . Server name: " + server_info.name + ", Players: " + str(server_info.count))

	if server_port == 0 || server_list.has(server_ip) || server_info.count > 1:
		return

	server_list.append(server_ip)
	server_found.emit(server_ip, server_info.name)

func set_up_listening() -> void:
	listener = PacketPeerUDP.new()
	server_list.clear()

	if (listener.bind(LISTEN_PORT) == OK):
		print("Bound to Listen Port " + str(LISTEN_PORT) + " Succesfull!")
	else:
		print("Failed to bind to Listen Port")

func set_up_broadcast(host_name: String) -> void:
	room_info.name = host_name
	room_info.count = 1
	broadcaster = PacketPeerUDP.new()
	broadcaster.set_broadcast_enabled(true)

	broadcaster.set_dest_address(BROADCAST_ADDRESS, LISTEN_PORT)

	if (broadcaster.bind(BROADCAST_PORT) == OK):
		print("Bound to Broadcast Port " + str(BROADCAST_PORT) + " Succesfull!")
		broadcastTimer.start()
	else:
		print("Failed to bind to Broadcast Port")

func _on_broadcast_timer_timeout() -> void:
	print("Broadcasting Game!")

	room_info.count = Lobby.players.size()

	# Usamos \n para separar informacion
	var data = room_info.name + "\n" + str(room_info.count)
	var packet = data.to_ascii_buffer()
	broadcaster.put_packet(packet)

func clean_up_broadcast() -> void:
	broadcastTimer.stop()
	if broadcaster != null:
		broadcaster.close()

func clean_up_listening() -> void:
	server_list.clear()
	if listener != null:
		listener.close()

func _exit_tree() -> void:
	clean_up_listening()
	clean_up_broadcast()
