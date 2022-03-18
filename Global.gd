extends Node

const SAVE_PATH = "user://savegame.sav"
const SECRET = "C220 Is the Best!"
var save_file = ConfigFile.new()

onready var HUD = get_node_or_null("/root/Game/UI/HUD")
onready var Coins = get_node_or_null("/root/Game/Coins")
onready var Mines = get_node_or_null("/root/Game/Mines")
onready var Game = load("res://Game.tscn")
onready var Coin = load("res://Coin/Coin.tscn")
onready var Mine = load("res://Mine/Mine.tscn")

var save_data = {
	"general": {
		"score":0
		,"health":100
		,"coins":[]
		,"mines":[]
		,"level":1
	}
}


func _ready():
	update_score(0)
	update_health(0)
	update_level(0)


func update_score(s):

	save_data["general"]["score"] += s
	HUD.find_node("Score").text = "Score: " + str(save_data["general"]["score"])

func update_health(h):
	save_data["general"]["health"] += h
	HUD.find_node("Health").text = "Health: " + str(save_data["general"]["health"])
	if save_data["general"]["health"] <= 0:
		load_game()
	
func update_level(l):
	save_data["general"]["level"] += l
	HUD.find_node("Level").text = "Level: " + str(save_data["general"]["level"])
	if save_data["general"]["level"] == 1:
		get_node("/root/Game/Player_Container").starting_position = Vector2(200,500)
	if save_data["general"]["level"] == 2:
		get_node("/root/Game/Player_Container").starting_position = Vector2(4362,500)
	if save_data["general"]["level"] == 3:
		get_node("/root/Game/Player_Container").starting_position = Vector2(7528,500)
	
	
func restart_level():
	HUD = get_node_or_null("/root/Game/UI/HUD")
	Coins = get_node_or_null("/root/Game/Coins")
	Mines = get_node_or_null("/root/Game/Mines")
	
	for c in Coins.get_children():
		c.queue_free()
	for m in Mines.get_children():
		m.queue_free()
	for c in save_data["general"]["coins"]:
		var coin = Coin.instance()
		coin.position = str2var(c)
		Coins.add_child(coin)
	for m in save_data["general"]["mines"]:
		var mine = Mine.instance()
		mine.position = str2var(m)
		Mines.add_child(mine)
	get_node("/root/Game/UI/Menu/Load").text = "Load Game: Level " + str(save_data["general"]["level"])
	update_score(0)
	update_health(0)
	update_level(0)
	get_tree().paused = false

# ----------------------------------------------------------
func save_game():
	save_data["general"]["coins"] = []					# creating a list of all the coins and mines that appear in the scene
	save_data["general"]["mines"] = []
	get_node("/root/Game/UI/Menu/Load").text = "Load Game: Level " + str(save_data["general"]["level"])
	for c in Coins.get_children():
		save_data["general"]["coins"].append(var2str(c.position))	# get a json representation of each of the coins
	for m in Mines.get_children():
		save_data["general"]["mines"].append(var2str(m.position))	# and mines
	var save_game = File.new()						# create a new file object
	save_game.open_encrypted_with_pass(SAVE_PATH, File.WRITE, SECRET)	# prep it for writing to, make sure the contents are encrypted
	save_game.store_string(to_json(save_data))				# convert the data to a json representation and write it to the file
	save_game.close()							# close the file so other processes can read from or write to it
	
func load_game():
	var save_game = File.new()						# Create a new file object
	if not save_game.file_exists(SAVE_PATH):				# If it doesn't exist, skip the rest of the function
		return
	save_game.open_encrypted_with_pass(SAVE_PATH, File.READ, SECRET)	# The file should be encrypted
	var contents = save_game.get_as_text()
	var result_json = JSON.parse(contents)
	if result_json.error == OK:
		save_data = result_json.result
	else:
		print("Error: ", result_json.error)
	save_game.close()
	var _scene = get_tree().change_scene_to(Game)
	call_deferred("restart_level")
