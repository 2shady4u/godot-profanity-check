extends Node

const BLOCKLIST_PATH := "res://addons/profanity-check/data/blocklist.txt"
const ALLOWLIST_PATH := "res://addons/profanity-check/data/allowlist.txt"
const PROFANITY_DISTANCE := 1

var verbose_mode := true

var _blocklist : PoolStringArray
var _allowlist : PoolStringArray

func _ready():
	_load_blocklist()
	_load_allowlist()

func _load_blocklist() -> void:
	var file := File.new()
	var error := file.open(BLOCKLIST_PATH, File.READ)
	if error == OK:
		var content : String = file.get_as_text()
		_blocklist = content.rsplit("\n")
	else:
		 push_error("Unable to open blocklist, is path available? (ERROR =" + str(error) + ")")

	file.close()

func _load_allowlist() -> void:
	var file := File.new()
	var error := file.open(ALLOWLIST_PATH, File.READ)
	if error == OK:
		var content : String = file.get_as_text()
		_allowlist = content.rsplit("\n")
	else:
		push_error("Unable to open allowlist, is path available? (ERROR =" + str(error) + ")")
	file.close()

func is_clean(string : String) -> bool:
	return not is_dirty(string)

func is_dirty(string : String) -> bool:
	var best_distance : int = 9223372036854775807
	var best_word : String = ""
	var time : int
	if verbose_mode:
		time = OS.get_system_time_msecs()

	if string in _allowlist:
		if verbose_mode: print("Word '" + string + "' is in allowlist")
		return false

	for i in range(_blocklist.size()):
		var distance : int = wf_optimized(string, _blocklist[i])
		if distance < best_distance:
			#print("Comparing " + string + " and " + dictionary[i])
			best_distance = distance
			best_word = _blocklist[i]

	if verbose_mode:
		var elapsed_time := OS.get_system_time_msecs() - time
		print("Closest word is '" + best_word + "' with distance " + str(best_distance) + " (" + str(elapsed_time) + " ms)")

	if best_distance <= PROFANITY_DISTANCE:
		return true
	else:
		return false

# Wagner-Fischer - Single Row Optimized Version (https://rosettacode.org/wiki/Levenshtein_distance)
# warning-ignore:unused_argument
# warning-ignore:unused_argument
static func wf_optimized(string_a : String, string_b : String) -> int:
	var length_a := string_a.length()
	var length_b := string_b.length()
	var row := range(0, length_a + 1)
	var diagonal : int

	for i in range(1, length_b + 1): # rows
		diagonal = row[0]
		row[0] += 1
		for j in range(1, length_a + 1): # columns
			var value : int
			if string_a[j - 1] == string_b[i - 1]:
				# STRINGS ARE THE SAME! JUST COPY THE DIAGONAL!
				value = diagonal
			else:
				value = 1 + [row[j], diagonal, row[j - 1]].min()

			diagonal = row[j]
			row[j] = value

	return row.back() as int

# Wagner-Fischer
static func wf(string_a : String, string_b : String) -> int:
	var length_a := string_a.length()
	var length_b := string_b.length()
	var matrix := range(0, length_a + 1)

	for i in range(1, length_b + 1):
		matrix.append(i)
		for _j in range(length_a):
			matrix.append(-1)

	for i in range(1, length_b + 1): # rows
		for j in range(1, length_a + 1): # columns
			if string_a[j - 1] == string_b[i - 1]:
				# STRTING ARE THE SAME! JUST COPY THE DIAGONAL!
				matrix[j + (length_a + 1)*i] = matrix[(j - 1) + (length_a + 1)*(i - 1)]
			else:
				var result := []
				for offset in [Vector2(-1,  0), Vector2( 0, -1), Vector2(-1, -1)]:
					var index : Vector2 = offset + Vector2(j, i)
					if (index.x + (length_a + 1)*index.y) <= matrix.size():
						result.append(matrix[index.x + (length_a + 1)*index.y])
				matrix[j + (length_a + 1)*i] = 1 + result.min()

	return matrix.back() as int

# Levenshtein (EXTREMELY SLOW)
static func lev(string_a : String, string_b : String) -> int:
	if string_a.length() == 0:
		return string_b.length()
	elif string_b.length() == 0:
		return string_a.length()

	#print("Comparing " + string_a + " and " + string_b)

	if string_a.substr(0,1) == string_b.substr(0,1):
		return lev(string_a.substr(1,-1), string_b.substr(1,-1))
	else:
		var result := []
		result.append(lev(string_a.substr(1,-1), string_b             ))
		result.append(lev(string_a             , string_b.substr(1,-1)))
		result.append(lev(string_a.substr(1,-1), string_b.substr(1,-1)))
		return 1 + result.min()
