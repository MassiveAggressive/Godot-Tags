@tool
class_name TagEditorUI extends PopupPanel

@onready var new_tag_line_edit: LineEdit = %NewTagLineEdit
@onready var add_new_tag_button: Button = %AddNewTagButton
@onready var tag_selector: TagSelectorUI = %TagSelectorUI

func _ready() -> void:
	add_new_tag_button.pressed.connect(OnAddNewTagButtonPressed)

func OnAddNewTagButtonPressed() -> void:
	AddTag(new_tag_line_edit.text)
	new_tag_line_edit.clear()

func AddTag(tag_name: String) -> void:
	if tag_name.is_empty():
		return
	
	TagManager.AddTag(tag_name)
