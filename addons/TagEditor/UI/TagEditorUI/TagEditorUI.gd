@tool
class_name TagEditorUI extends PopupPanel

@onready var new_tag_name_input: LineEdit = %NewTagNameInput
@onready var add_tag_button: Button = %AddTagButton
@onready var tag_selector_ui: TagSelectorUI = $VBoxContainer/ScrollContainer/TagSelectorUI

signal TagsChanged(tags: Array[StringName])

func _ready() -> void:
	hide()
	add_tag_button.pressed.connect(OnAddTagButtonPressed)
	new_tag_name_input.text_submitted.connect(func(_text): OnAddTagButtonPressed())
	tag_selector_ui.SelectedTagsChanged.connect(func(tags): TagsChanged.emit(tags))

func SetSelectedTags(tags: Array[StringName]) -> void:
	# Ensure the UI is ready before setting tags
	if not is_node_ready():
		await ready
	
	tag_selector_ui.selected_tags = tags.duplicate()
	tag_selector_ui.RefreshTree()

func OnAddTagButtonPressed() -> void:
	var tag_name: String = new_tag_name_input.text.strip_edges()
	if tag_name.is_empty():
		return
	
	TagManager.AddTagName(StringName(tag_name))
	new_tag_name_input.clear()
