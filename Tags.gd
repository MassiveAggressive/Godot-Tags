@tool
extends EditorPlugin

var tag_inspector: TagEditorInspectorPlugin

func _enter_tree() -> void:
	add_autoload_singleton("TagManager", "res://addons/Tags/TagManager/TagManager.gd")
	
	tag_inspector = TagEditorInspectorPlugin.new()
	add_inspector_plugin(tag_inspector)

func _exit_tree() -> void:
	remove_autoload_singleton("TagManager")
	remove_inspector_plugin(tag_inspector)
