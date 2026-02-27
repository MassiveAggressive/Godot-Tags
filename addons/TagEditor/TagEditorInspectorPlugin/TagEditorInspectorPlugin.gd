@tool
class_name TagEditorInspectorPlugin extends EditorInspectorPlugin

var tag_editor_ui: TagEditorUI

func _init() -> void:
	print("TagEditorInspectorPlugin _init")
	
	tag_editor_ui = preload("res://addons/TagEditor/UI/TagEditorUI/TagEditorUI.tscn").instantiate()

func _can_handle(object: Object) -> bool:
	return true

func _parse_property(object: Object, type: Variant.Type, name: String, hint_type: PropertyHint, hint_string: String, usage_flags: int, wide: bool) -> bool:
	if hint_string == "TagContainer":
		var tag_editor_property: TagContainerEditorProperty = TagContainerEditorProperty.new(tag_editor_ui)
		
		add_property_editor(name, tag_editor_property)
		return true
	
	return false
