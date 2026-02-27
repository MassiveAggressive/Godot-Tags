@tool
extends Node

signal TagsUpdated

var tag_database: Dictionary[StringName, Array]

func _init() -> void:
	var config: ConfigFile = ConfigFile.new()
	
	var error: Error = config.load("res://Save/TagDatabase/TagDatabase.ini")
	
	if error == OK:
		var saved_tags: Array[StringName] = config.get_value("Tags", "tags", null)
		
		if saved_tags != null:
			for tag_name in saved_tags:
				CalculateTag(tag_name)

func CalculateTag(tag_name: StringName):
	var parts = tag_name.split(".")
	var current_hierarchy: Array[StringName] = []
	var current_path = ""
	
	for i in range(parts.size()):
		if i > 0:
			current_path += "."
		current_path += parts[i]
		
		var current_tag = StringName(current_path)
		
		current_hierarchy.append(current_tag)
		
		if not tag_database.has(current_tag):
			tag_database[current_tag] = current_hierarchy.duplicate()
	
	var config: ConfigFile = ConfigFile.new()
	
	config.set_value("Tags", "tags", tag_database.keys())
	config.save("res://Save/TagDatabase/TagDatabase.ini")
	
	TagsUpdated.emit()

func GetTagHierarchy(tag_name: StringName) -> Array[StringName]:
	return tag_database.get(tag_name, [tag_name])

func AddTag(tag_name: StringName) -> void:
	if tag_database.has(tag_name):
		return
	
	CalculateTag(tag_name)	
