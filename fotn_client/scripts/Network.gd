extends Node

var client = WebSocketClient.new()
var url = 'ws://127.0.0.1:5000'

signal player_is_login()
signal player_is_logged()
signal player_is_disconnected()
signal player_has_move()
signal player_is_attacked()
signal player_on_counter()
signal player_end_counter()
signal player_stamina_update()
signal player_run_attack()
signal player_is_dead()

func _ready():
	client.connect('data_received', self, 'data_received')
	
	var err = client.connect_to_url(url)
	
	if err:
		set_process(false)
		print("Unable to connect", err)
		
	get_tree().set_auto_accept_quit(false)

func _notification(what):
	if (what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST):
		for _node in get_tree().get_root().get_children():
			if _node.name.split("_")[0] == "Player":
				sendData({ "uid": _node._uid }, "Disconnected")
		get_tree().quit()

func _process(_delta):
	client.poll()
	
func data_received():
	var data = client.get_peer(1).get_packet().get_string_from_utf8()
		
	if !data || data == '[object Object]':
		return
	
	var payload = JSON.parse(data).result
	
	if payload && payload.code && payload.code == 200:
		emit_signal(payload.event, payload.data)

func login(pseudo, color):
	sendData({ 'pseudo': pseudo, 'color': color }, 'ConnectPlayer')
	
func movePlayer(position, playerUid):
	sendData({ 'position': position, 'uid': playerUid}, 'PlayerOnMove')

func attackPlayer(attackType, defendPlayerUid, attackPlayerUid):
	sendData({
		'attackType': attackType,
		'defendPlayerUid': defendPlayerUid,
		'attackPlayerUid': attackPlayerUid
	}, 'AttackPlayer')

func runCounter(uid):
	sendData({ 'counter': true, 'uid': uid}, 'RunCounter')

func runAttack(attackType, uid):
	sendData({ 'attackType': attackType, 'uid': uid}, 'RunAttack')

func sendData(data, eventName):
	client.get_peer(1).put_packet(JSON.print({
		'data': data,
		'event': eventName 
	}).to_utf8())
