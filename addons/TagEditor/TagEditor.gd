@tool
extends EditorPlugin

var tag_editor_inspector_plugin: TagEditorInspectorPlugin

func _enter_tree() -> void:
	print("TagEditor _enter_tree")
	
	tag_editor_inspector_plugin = TagEditorInspectorPlugin.new()
	add_inspector_plugin(tag_editor_inspector_plugin)
	
	add_autoload_singleton("TagManager", "res://addons/TagEditor/TagManager/TagManager.gd")

func _exit_tree() -> void:
	remove_inspector_plugin(tag_editor_inspector_plugin)
