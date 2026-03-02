class_name TagContainerEditorProperty extends EditorProperty

var edited_tag_container: TagContainer

var tag_container_editor_property_ui: Button
var tag_editor_ui: TagEditorUI

func _init(_tag_editor_ui: TagEditorUI) -> void:
	tag_editor_ui = _tag_editor_ui
	tag_editor_ui.tag_selector.TagsUpdated.connect(OnTagsUpdated)
	
	tag_container_editor_property_ui = preload("res://addons/TagEditor/UI/TagContainerEditorPropertyUI/TagContainerEditorPropertyUI.tscn").instantiate()
	
	add_child(tag_container_editor_property_ui)
	add_focusable(tag_container_editor_property_ui)
	
	tag_container_editor_property_ui.pressed.connect(OnButtonPressed)

func _update_property() -> void:
	edited_tag_container = get_edited_object()[get_edited_property()]
	
	if !edited_tag_container:
		emit_changed(get_edited_property(), TagContainer.new())

func OnButtonPressed() -> void:
	tag_editor_ui.tag_selector.selected_tag_names = edited_tag_container.tags
	
	var button_position: Vector2 = tag_container_editor_property_ui.get_screen_transform().origin
	var popup_panel_position: Vector2 = button_position + Vector2(0.0, tag_container_editor_property_ui.size.y)
	
	tag_editor_ui.popup(Rect2(popup_panel_position, Vector2(300.0, 300.0)))

func OnTagsUpdated() -> void:
	var selected_tag_names: Array[StringName] = tag_editor_ui.tag_selector.selected_tag_names
	
	for tag_name in selected_tag_names:
		if !edited_tag_container.HasTag(tag_name):
			edited_tag_container.AddTagName(tag_name)
	
	emit_changed(get_edited_property(), edited_tag_container)
