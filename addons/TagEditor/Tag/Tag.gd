class_name Tag extends Resource

var tag_name: StringName

var parts: Array[StringName]
var parents: Array[StringName]
var head: StringName
var tail: StringName

func _init(_tag_name: StringName) -> void:
	tag_name = _tag_name
	
	for part: StringName in tag_name.split("."):
		parts.append(part)
	
	var current_name: StringName = ""
	
	for i: int in parts.size():
		if i > 0:
			current_name += "."
		
		current_name += parts[i]
		
		parents.append(current_name)
	
	head = parts[0]
	tail = parts[parts.size() - 1]

func BeginsWith(compared_tag_name: StringName) -> void:
	return parents.has(compared_tag_name)
