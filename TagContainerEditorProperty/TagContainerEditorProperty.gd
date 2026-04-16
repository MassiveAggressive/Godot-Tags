@tool
class_name TagContainerEditorProperty extends EditorProperty

var button_scene: PackedScene = preload("res://addons/Tags/UI/TagContainerEditorPropertyUI/TagContainerEditorPropertyUI.tscn")
var button: TagContainerEditorPropertyUI

var edited_container: TagContainer

var tag_editor_ui: TagEditorUI

func _init(_tag_editor_ui: TagEditorUI) -> void:
	tag_editor_ui = _tag_editor_ui
	button = button_scene.instantiate()
	
	add_child(button)
	add_focusable(button)
	
	button.pressed.connect(OnButtonPressed)

func OnButtonPressed() -> void:
	for connection in tag_editor_ui.SelectedTagsChanged.get_connections():
		tag_editor_ui.SelectedTagsChanged.disconnect(connection.callable)
	
	tag_editor_ui.SetSelectedTags(edited_container.GetDefaultTags())
	tag_editor_ui.SelectedTagsChanged.connect(OnSelectedTagsChanged)
	
	var popup_pos: Vector2i = Vector2i(button.get_screen_transform().get_origin())
	popup_pos.y += int(button.size.y)
	tag_editor_ui.popup(Rect2i(popup_pos, tag_editor_ui.size))

func OnSelectedTagsChanged(tags: Array[StringName]) -> void:
	edited_container.default_tags = tags.duplicate()
	emit_changed(get_edited_property(), edited_container)

func _update_property() -> void:
	var value = get_edited_object()[get_edited_property()]
	
	if value is TagContainer:
		edited_container = value
	else:
		edited_container = TagContainer.new()
		emit_changed(get_edited_property(), edited_container)
