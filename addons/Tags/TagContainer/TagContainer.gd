@tool
class_name TagContainer extends Resource

signal TagAdded(tag_id: int)
signal TagRemoved(tag_id: int)

@export var default_tags: Array[StringName]:
	set(value):
		default_tags = value
		for tag_name: StringName in default_tags:
			AddTagName(tag_name)

var added_tags: Dictionary[int, int]
var hierarchical_tag_count: Dictionary[int, int]

func AddDefaultTag(tag_name: StringName) -> void:
	default_tags.append(tag_name)

func SetDefaultTags(_default_tags: Array[StringName]) -> void:
	default_tags = _default_tags.duplicate()

func GetDefaultTags() -> Array[StringName]:
	return default_tags.duplicate()

func AddTagName(tag_name: StringName) -> void:
	AddTag(TagManager.GetTagId(tag_name))

func AddTag(tag_id: int) -> void:
	added_tags[tag_id] = added_tags.get(tag_id, 0) + 1
	
	for parent_id: int in TagManager.GetParentIdsById(tag_id):
		hierarchical_tag_count[parent_id] = hierarchical_tag_count.get(parent_id, 0) + 1
		
		TagAdded.emit(parent_id)

func AddTags(tags_to_add: TagContainer) -> void:
	for tag_id: int in tags_to_add.added_tags:
		AddTag(tag_id)

func RemoveTagName(tag_name: StringName) -> void:
	RemoveTag(TagManager.GetTagId(tag_name))

func RemoveTag(tag_id: int) -> void:
	added_tags[tag_id] = added_tags.get(tag_id, 0) - 1
	
	if hierarchical_tag_count[tag_id] <= 0:
		hierarchical_tag_count.erase(tag_id)
	
	for parent_id: int in TagManager.GetChildrenIdsById(tag_id):
		hierarchical_tag_count[parent_id] = hierarchical_tag_count.get(parent_id, 0) - 1
		
		TagRemoved.emit(parent_id)
		
		if hierarchical_tag_count[parent_id] <= 0:
			hierarchical_tag_count.erase(parent_id)

func RemoveTags(tags_to_remove: TagContainer) -> void:
	for tag_id: int in tags_to_remove.added_tags:
		RemoveTag(tag_id)

func HasTagName(tag_name: StringName, exact_match: bool = false) -> bool:
	return HasTag(TagManager.GetTagId(tag_name), exact_match)

func HasTag(tag_id: int, exact_match: bool = false) -> bool:
	if exact_match:
		return added_tags.has(tag_id)
	
	return hierarchical_tag_count.has(tag_id)

func GetTagNames() -> Array[StringName]:
	var selected_tag_names: Array[StringName]
	
	for tag_id in hierarchical_tag_count:
		selected_tag_names.append(TagManager.GetTagName(tag_id))
	
	return selected_tag_names
