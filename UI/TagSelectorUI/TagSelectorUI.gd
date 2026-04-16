@tool
class_name TagSelectorUI extends Tree

signal SelectedTagsChanged(tags: Array[StringName])

var tag_items: Dictionary[StringName, TreeItem]
var selected_tags: Array[StringName]

func _ready() -> void:
	columns = 2
	set_column_titles_visible(false)
	set_column_expand(0, false)
	set_column_custom_minimum_width(0, 30)
	hide_root = true
	
	item_edited.connect(OnTreeItemEdited)
	
	TagManager.TagNameRegistered.connect(OnTagRegistered)
	TagManager.TagNameUnregistered.connect(OnTagRegistered)
	
	RefreshTree()

func OnTagRegistered(_tag_name: StringName) -> void:
	RefreshTree()

func OnTreeItemEdited() -> void:
	var item: TreeItem = get_edited()
	var tag_name: StringName = item.get_metadata(1)
	var is_checked: bool = item.is_checked(0)
	
	if is_checked:
		if not selected_tags.has(tag_name):
			selected_tags.append(tag_name)
	else:
		selected_tags.erase(tag_name)
	
	SelectedTagsChanged.emit(selected_tags)

func RefreshTree() -> void:
	clear()
	tag_items.clear()
	
	var root: TreeItem = create_item()
	tag_items[&""] = root
	
	for tag_name: StringName in TagManager.registered_tag_names:
		CreateTreeItem(tag_name)
	
	for tag_name in selected_tags:
		if tag_items.has(tag_name):
			tag_items[tag_name].set_checked(0, true)

func GetParentTreeItem(tag_name: StringName) -> TreeItem:
	var dot: int = tag_name.rfind(".")
	var parent_path: StringName = &""
	if dot >= 0:
		parent_path = StringName(tag_name.substr(0, dot))
	
	return tag_items.get(parent_path, tag_items.get(&""))

func CreateTreeItem(tag_name: StringName) -> TreeItem:
	if tag_items.has(tag_name):
		return tag_items[tag_name]
	
	var parent_item: TreeItem = GetParentTreeItem(tag_name)
	var item: TreeItem = create_item(parent_item)
	
	var parts: Array[StringName] = TagManager.ParseTagName(tag_name)
	var display_name: StringName = parts[-1]
	
	item.set_cell_mode(0, TreeItem.CELL_MODE_CHECK)
	item.set_editable(0, true)
	
	item.set_text(1, display_name)
	item.set_metadata(1, tag_name)
	
	tag_items[tag_name] = item
	
	return item
