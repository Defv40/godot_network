extends Node

var peer = ENetMultiplayerPeer.new()
@onready var peer_label = $"../Control/peer"

@onready var messanger = $"../Control/messanger"
@onready var server = $"../Control/VBoxContainer/server"
@onready var client = $"../Control/VBoxContainer/client"
@onready var user_input = $"../Control/user_input"

@onready var player = preload("res://Player/Player.tscn")
@onready var btn_send_message = $"../Control/send_message"




var peers_connections = []
var connection_message = ""

func _activate_chat():
	messanger.visible = true
	user_input.visible = true
	btn_send_message.visible = true
	
	
func _disactivate_chat():
	messanger.visible = false
	user_input.visible = false
	btn_send_message.visible = false
	messanger.text = ""
	
	
func _ready():
	peer_label.text = "Offline"
	
	_disactivate_chat()
	
	peer.peer_connected.connect(peer_connect)
	peer.peer_disconnected.connect(peer_disconnect)
	multiplayer.connected_to_server.connect(user_connect_to_server)
	multiplayer.server_disconnected.connect(server_disconnect)

func peer_disconnect(id):
	print("Пользователь  " + str(id) + " вышел")
	#delete_player(id)
	
	
func peer_connect(id):
	peers_connections.append(id)
	
	#create_player(id)
#	if multiplayer.is_server():
#		print("вызвал")
		#rpc("send_all_chat", messanger.text)
	#network_debug(id)

# нажал на кнопку сервер
func _on_server_pressed():
#	if connection_message == "0":
#		print("sorry server already using")
#		return
	server.disabled = true
	client.disabled = true
	connection_message = str(peer.create_server(3020))  
	print("server has been created")
	multiplayer.multiplayer_peer = peer
	peer_label.text = "Server, id: " + str(multiplayer.get_unique_id())
	Global.local_player = multiplayer.get_unique_id()
	_activate_chat()
	create_player(multiplayer.get_unique_id())

# нажал на кнопку клиент	
func _on_client_pressed():
	server.disabled = true
	client.disabled = true
	peer.create_client("127.0.0.1", 3020)
	multiplayer.multiplayer_peer = peer
	peer_label.text = "Client, id: " + str(multiplayer.get_unique_id())
	Global.local_player = multiplayer.get_unique_id()
	#set_multiplayer_authority(multiplayer.get_unique_id())
	
# удаление перса
func delete_player(id : int):
	#var pl = get_node("../List_CONNECTED_PLAYERS/Игрок " + str(id))
	#pl.queue_free()
	pass
	
# создание перса ( возможно только для сервера)
func create_player(id : int):
	var pl = player.instantiate()
	pl.name = str(id)
	pl.set_multiplayer_authority(id)
	#list_connected_players.add_child(pl)
	
@rpc (any_peer)
func create_player_on_server(id : int):
	create_player(id)
#chat 	
func user_connect_to_server():
	_activate_chat()
	create_player(multiplayer.get_unique_id())
	#rpc_id(1, "create_player_on_server", multiplayer.get_unique_id())
	rpc_id(1, "server_give_data")

func server_disconnect():
	print("метод выхода с сервера")
	dis()


#@rpc(call_remote, any_peer)
#func disconnect_all_users():
#	peer.close()
#	multiplayer.multiplayer_peer.close()
	
@rpc(any_peer)
func server_give_data():
	var sender_id = multiplayer.get_remote_sender_id()
	rpc_id(sender_id, "send_all_chat", messanger.text)

@rpc(call_remote, any_peer)	
func send_all_chat(text : String):
	messanger.text = text




func network_debug(id):
	print("=================================================")
	print("Сервер: " + str(multiplayer.is_server()))
	print("Присоединился: " + str(id))
	print("Наш айди пир" + str(peer.get_unique_id()))
	print("Наш айди мультиплеера " + str(multiplayer.get_unique_id()))
	print("Мы авторизованы: " + str(is_multiplayer_authority()))
	print("Наш авторизованный айди" + str(get_multiplayer_authority()))
	print("=================================================")

@rpc(call_local, any_peer)
func send_message(id_sender : int, text_sender):
	if (id_sender == multiplayer.get_unique_id()):
		user_input.text = ""
	messanger.text = messanger.text + "\n" + str(id_sender) + ": " + text_sender
	
func _on_send_message_pressed():
	rpc("send_message", multiplayer.get_unique_id(), user_input.text)
	

	

# для сервера
func dis():
	peer.close()
	multiplayer.multiplayer_peer.close()
	peer_label.text = "Offline"
	_disactivate_chat()
	server.disabled = false
	client.disabled = false
	
func _on_button_pressed():
	#delete_player(1)
	dis()
