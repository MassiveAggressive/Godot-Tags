@tool
class_name TagContainer extends Resource

@export var tags: Array[StringName]

func AddTag(tag_name: StringName) -> void:
	tags.append(tag_name)

func RemoveTag(tag_name: StringName) -> void:
	tags.erase(tag_name)

func HasTag(tag_name: StringName) -> bool:
	return tags.has(tag_name)

func _iter_init(iter: Array) -> bool:
	iter[0] = 0
	return iter[0] < tags.size()

func _iter_next(iter: Array) -> bool:
	iter[0] += 1
	return iter[0] < tags.size()

func _iter_get(iter: Variant) -> Variant:
	return tags[iter[0]]
