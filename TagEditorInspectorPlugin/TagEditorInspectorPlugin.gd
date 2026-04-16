class_name TagEditorInspectorPlugin extends EditorInspectorPlugin

var tag_editor_ui_scene: PackedScene = preload("res://addons/Tags/UI/TagEditorUI/TagEditorUI.tscn")
var tag_editor_ui: TagEditorUI

func _init() -> void:
	tag_editor_ui = tag_editor_ui_scene.instantiate()
	
	EditorInterface.get_base_control().add_child(tag_editor_ui)

func _can_handle(object: Object) -> bool:
	return true

func _parse_property(object: Object, type: Variant.Type, name: String, hint_type: PropertyHint, hint_string: String, usage_flags: int, wide: bool) -> bool:
	if hint_string == "TagContainer":
		add_property_editor(name, TagContainerEditorProperty.new(tag_editor_ui))
		
		return true
	
	return false

func _notification(what: int) -> void:
	if what == NOTIFICATION_PREDELETE:
		tag_editor_ui.queue_free()
