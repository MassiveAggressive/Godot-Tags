@tool
extends Node

signal TagNameRegistered(tag_name: StringName)
signal TagNameUnregistered(tag_name: StringName)
signal TagsUpdated

var config_path: String = "res://addons/Tags/TagDatabase.ini"

var tag_names: Array[StringName]

var registered_tag_names: Array[StringName]

var name_to_id: Dictionary[StringName, int]
var id_to_name: Dictionary[int, StringName]

var parents_hierarchy: Dictionary[int, PackedInt32Array]
var children_hierarchy: Dictionary[int, PackedInt32Array]

func _init() -> void:
	var config: ConfigFile = ConfigFile.new()
	var error: Error = config.load(config_path)
	
	if error == OK:
		tag_names = config.get_value("Tags", "tags", null)
		
		if tag_names != null:
			for tag_name: StringName in tag_names:
				RegisterTagName(tag_name)

func AddTagName(tag_name: StringName) -> void:
	if registered_tag_names.has(tag_name):
		return
	
	tag_names.append(tag_name)
	
	RegisterTagName(tag_name)
	SaveTags()

func RemoveTagName(tag_name: StringName) -> void:
	if !registered_tag_names.has(tag_name):
		return
	
	tag_names.erase(tag_name)
	
	UnregisterTagName(tag_name)
	
	SaveTags()

func GetNewId() -> int:
	if !id_to_name.is_empty():
		return id_to_name.keys().max() + 1
	
	return 0

func RegisterTagName(tag_name: StringName) -> int:
	if registered_tag_names.has(tag_name):
		return -1
	
	var dot: int = tag_name.rfind(".")
	
	if dot >= 0:
		RegisterTagName(tag_name.substr(0, dot))
	
	var new_tag_id: int = GetNewId()
	
	registered_tag_names.append(tag_name)
	name_to_id[tag_name] = new_tag_id
	id_to_name[new_tag_id] = tag_name
	
	TagNameRegistered.emit(tag_name)
	
	ClearCache()
	
	return new_tag_id

func UnregisterTagName(tag_name: StringName) -> void:
	if !registered_tag_names.has(tag_name):
		return
	
	for tag_id: int in GetChildrenIdsById(name_to_id[tag_name]):
		var temp_name: StringName = id_to_name[tag_id]
		
		registered_tag_names.erase(temp_name)
		id_to_name.erase(tag_id)
		name_to_id.erase(temp_name)
		
		TagNameUnregistered.emit(temp_name)
	
	ClearCache()

func RegisterParentsById(tag_id: int) -> void:
	if parents_hierarchy.has(tag_id):
		return
	
	var tag_name: StringName = id_to_name[tag_id]
	var parents_id: PackedInt32Array = PackedInt32Array()
	var parts: Array[StringName] = ParseTagName(tag_name)
	var current_name: StringName = ""
	
	for count: int in range(parts.size()):
		if count > 0:
			current_name += "."
		
		current_name += parts[count]
		
		if name_to_id.has(current_name):
			parents_id.append(name_to_id[current_name])
	
	parents_hierarchy[tag_id] = parents_id

func RegisterChildrenById(tag_id: int) -> void:
	if children_hierarchy.has(tag_id):
		return
	
	var parent_tag_name: StringName = id_to_name[tag_id]
	var children_id: PackedInt32Array = PackedInt32Array()
	
	for tag_name: StringName in name_to_id.keys():
		if tag_name.begins_with(parent_tag_name):
			children_id.append(name_to_id[tag_name])
	
	children_hierarchy[tag_id] = children_id

func ClearCache() -> void:
	parents_hierarchy.clear()
	children_hierarchy.clear()

func GetParentIdsById(tag_id: int) -> PackedInt32Array:
	RegisterParentsById(tag_id)
	
	return parents_hierarchy[tag_id]

func GetParentIdsByName(tag_name: StringName) -> PackedInt32Array:
	return GetParentIdsById(name_to_id[tag_name])

func GetChildrenIdsById(tag_id: int) -> PackedInt32Array:
	RegisterChildrenById(tag_id)
	
	return children_hierarchy[tag_id]

func GetChildrenIdsByName(tag_name: StringName) -> PackedInt32Array:
	return GetChildrenIdsById(name_to_id[tag_name])

func GetParentNamesById(tag_id: int) -> Array[StringName]:
	var parent_ids: PackedInt32Array = GetParentIdsById(tag_id)
	var parent_tag_names: Array[StringName]
	
	for parent_id: int in parent_ids:
		parent_tag_names.append(id_to_name[parent_id])
	
	return parent_tag_names

func GetParentNamesByName(tag_name: StringName) -> Array[StringName]:
	return GetParentNamesById(name_to_id[tag_name])

func GetChildrenNamesById(tag_id: int) -> Array[StringName]:
	var children_ids: PackedInt32Array = GetChildrenIdsById(tag_id)
	var children_tag_names: Array[StringName]
	
	for children_id: int in children_ids:
		children_tag_names.append(id_to_name[children_id])
	
	return children_tag_names

func GetChildrenNamesByName(tag_name: StringName) -> Array[StringName]:
	return GetChildrenNamesById(name_to_id[tag_name])

func ParseTagName(tag_name: StringName) -> Array[StringName]:
	var parts: Array[StringName]
	
	for part: StringName in tag_name.split("."):
		parts.append(part)
	
	return parts

func GetTagId(tag_name: StringName) -> int:
	return name_to_id[tag_name]

func GetTagName(tag_id: int) -> StringName:
	return id_to_name[tag_id]

func SaveTags() -> void:
	var config: ConfigFile = ConfigFile.new()
	
	config.set_value("Tags", "tags", tag_names)
	config.save(config_path)
