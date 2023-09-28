extends Node3D

const FILE_NAME = "res://all_symmetries/mapping.res"

@onready var gmap: GridMap = get_node("GridMap")
var table = {0: [-1, -1]}
var index = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	#for i in range(256):
	#	if not i in table:
	#		table[i] = [-1, -1]
	load_table()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	handle_inputs()
	update_view()

func handle_inputs():
	if not $Timer.is_stopped():
		return
	$Timer.start()

	if Input.is_key_pressed(KEY_O) and index < 255:
		index += 1
	if Input.is_key_pressed(KEY_I) and index > 0:
		index -= 1

	if Input.is_key_pressed(KEY_R) and table[index][0] < 21:
		table[index][0] += 1
	if Input.is_key_pressed(KEY_F) and table[index][0] >= 0:
		table[index][0] -= 1

	if Input.is_key_pressed(KEY_T) and table[index][1] < 23:
		table[index][1] += 1
	if Input.is_key_pressed(KEY_G) and table[index][1] > 0:
		table[index][1] -= 1

	#if Input.is_key_pressed(KEY_M):
	#	save_table()
	#if Input.is_key_pressed(KEY_N):
	#	load_table()


func update_view():
	$GridContainer/Index.text = str(index)
	$GridContainer/Model.text = str(table[index][0])
	$GridContainer/Orient.text = str(table[index][1])
	for z in [0, 1]:
		for y in [0, 1]:
			for x in [0, 1]:
				var q = 4 * z + 2 * y + 1 * x
				var i = 1 << q
				var n: Node3D = get_node("Markers/Marker_%d%d%d" % [z, y, x])
				n.visible = index & i != 0
				var l: Label3D = get_node("Labels/Label3D-%d" % [i])
				l.modulate = Color.RED if index & i != 0 else Color.WHITE
	gmap.set_cell_item(
		Vector3i(0, 0, 0),
		 table[index][0],
		 table[index][1],
	)


func _input(event):
		print("index: %d" % [index])
		print("model: %d" % [table[index][0]])
		print("orient: %d" % [table[index][1]])

func save_table():
	FileAccess.open(FILE_NAME, FileAccess.WRITE).store_string(JSON.stringify(table))

func load_table():
	var file = FileAccess.open(FILE_NAME, FileAccess.READ)
	var z = JSON.parse_string(file.get_as_text())
	for i in range(256):
		table[i] = z[str(i)]
