@tool
extends GridMap

@export_file()
var table_file: String

@export var source: GridMap

@export var outie: bool

const hood = [
	[Vector3i(-1, -1, -1), 1],
	[Vector3i(+0, -1, -1), 2],
	[Vector3i(-1, +0, -1), 4],
	[Vector3i(+0, +0, -1), 8],
	[Vector3i(-1, -1, +0), 16],
	[Vector3i(+0, -1, +0), 32],
	[Vector3i(-1, +0, +0), 64],
	[Vector3i(+0, +0, +0), 128],
]

var table = {}
var map = {}
var time = 0

func _ready() -> void:
	load_table()
	reset()
	_redo()
	
func _process(delta):
	time += delta
	if time > 0.5:
		time = 0
		_redo()

func _redo() -> void:
	var new_map = _read_source(source)
	_write_dest(new_map, outie)
	map = new_map

func _write_dest(new_map: Dictionary, outie: bool) -> void:
	for v in new_map.keys():
		var i = new_map.get(v, 0)
		if map.get(v, 0) != i:
			if not outie:
				i = 255 - i
			var item_ori = table.get(i, [-1, -1])
			set_cell_item(v, item_ori[0], item_ori[1])
		map.erase(v)

	# Deleted cells: present in old, but not new
	for v in map.keys():
		set_cell_item(v, -1, -1)

func _read_source(source: GridMap) -> Dictionary:
	if not source:
		return {}

	var new_map = {}

	for v in source.get_used_cells():
		for offset_bits in hood:
			var w = v - offset_bits[0]
			new_map[w] = new_map.get(w, 0) + offset_bits[1]

	return new_map

func load_table() -> void:
	var file = FileAccess.open(table_file, FileAccess.READ)
	var data = JSON.parse_string(file.get_as_text()) if file else {}

	if not data:
		print("WARNING: autotile table data could not be loaded")

	for i in range(256):
		table[i] = data.get(str(i), [-1, -1])

func reset() -> void:
	clear()
	map = {}
