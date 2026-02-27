class_name TagContainerEditorProperty extends EditorProperty

var current_tags: Array[StringName]

var tag_container_editor_property_ui: Button
var tag_editor_ui: TagEditorUI

func _init(_tag_editor_ui: TagEditorUI) -> void:
	tag_editor_ui = _tag_editor_ui
	
	tag_container_editor_property_ui = preload("res://addons/TagEditor/UI/TagContainerEditorPropertyUI/TagContainerEditorPropertyUI.tscn").instantiate()
	
	add_child(tag_container_editor_property_ui)
	add_focusable(tag_container_editor_property_ui)
	
	tag_container_editor_property_ui.pressed.connect(OnButtonPressed)

func OnButtonPressed() -> void:
	if tag_editor_ui.get_parent() != null:
		tag_editor_ui.get_parent().remove_child(tag_editor_ui)
	
	add_child(tag_editor_ui)
	
	var button_position: Vector2 = tag_container_editor_property_ui.get_screen_transform().origin
	var popup_panel_position: Vector2 = button_position + Vector2(0.0, tag_container_editor_property_ui.size.y)
	
	tag_editor_ui.popup(Rect2(popup_panel_position, Vector2(300.0, 300.0)))

func _exit_tree() -> void:
	if tag_editor_ui.get_parent():
		tag_editor_ui.get_parent().remove_child(tag_editor_ui)
