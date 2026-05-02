@tool
class_name TagEditorUI extends PopupPanel

signal SelectedTagsChanged(tags: Array[StringName])

@onready var new_tag_name_input: LineEdit = %NewTagNameInput
@onready var add_tag_button: Button = %AddTagButton
@onready var tag_selector_ui: TagSelectorUI = %TagSelectorUI

func _ready() -> void:
	new_tag_name_input.text_submitted.connect(OnAddTagButtonPressed)
	add_tag_button.pressed.connect(OnAddTagButtonPressed)
	tag_selector_ui.SelectedTagsChanged.connect(func(tags: Array[StringName]): SelectedTagsChanged.emit(tags))

func SetSelectedTags(tags: Array[StringName]) -> void:
	tag_selector_ui.selected_tags = tags

func OnAddTagButtonPressed(submitted_text: String = "") -> void:
	var tag_name: String = new_tag_name_input.text.strip_edges()
	
	if tag_name.is_empty():
		return
	
	TagManager.AddTagName(StringName(tag_name))
	new_tag_name_input.clear()
