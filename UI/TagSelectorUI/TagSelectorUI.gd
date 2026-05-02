@tool
class_name TagSelectorUI extends Tree

signal SelectedTagsChanged(tags: Array[StringName])

var items: Dictionary[StringName, TreeItem]
var selected_tags: Array[StringName]:
	set = SetSelectedTags

func _ready() -> void:
	columns = 3
	set_column_titles_visible(false)
	set_column_expand(0, false)
	set_column_expand(2, false)
	set_column_custom_minimum_width(2, 60)
	hide_root = true
	
	item_edited.connect(OnTreeItemEdited)
	item_selected.connect(OnTreeItemClicked)
	
	TagManager.TagNameRegistered.connect(OnTagRegistered)
	TagManager.TagNameUnregistered.connect(OnTagUnregistered)
	
	RefreshTree()

func SetSelectedTags(_selected_tags: Array[StringName]) -> void:
	for tag_name: StringName in selected_tags:
		CheckItem(tag_name)
	
	selected_tags = _selected_tags
	
	for tag_name: StringName in selected_tags:
		CheckItem(tag_name, true)

func OnTagRegistered(tag_name: StringName) -> void:
	RefreshTree()

func OnTagUnregistered(tag_name: StringName) -> void:
	selected_tags.erase(tag_name)
	
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

func OnTreeItemClicked() -> void:
	var item: TreeItem = get_selected()
	var tag_name: StringName = item.get_metadata(1)
	var column: int = get_selected_column()
	
	if column == 2:
		TagManager.call_deferred("RemoveTagName", tag_name)

func RefreshTree() -> void:
	clear()
	items.clear()
	
	GetOrCreateItem()
	
	for tag_name: StringName in TagManager.registered_tag_names:
		print(tag_name)
		GetOrCreateItem(tag_name)

func GetOrCreateItem(tag_name: StringName = &"") -> TreeItem:
	if items.has(tag_name):
		return items[tag_name]
	
	if tag_name == &"":
		var root: TreeItem = create_item()
		
		items[&""] = root
		
		return root
	
	var parents_names: Array[StringName] = TagManager.GetParentNamesByName(tag_name)
	var parent_name: StringName = &""
	
	if parents_names.size() > 1:
		parent_name = parents_names[-2]
	
	var parent_item: TreeItem = GetOrCreateItem(parent_name)
	
	var item: TreeItem = create_item(parent_item)
	var display_name: StringName = TagManager.ParseTagName(tag_name)[-1]
	
	item.set_cell_mode(0, TreeItem.CELL_MODE_CHECK)
	item.set_editable(0, true)
	
	item.set_text(1, display_name)
	item.set_metadata(1, tag_name)
	
	item.set_custom_as_button(2, true)
	item.set_text(2, "Delete")
	item.set_text_alignment(2, HORIZONTAL_ALIGNMENT_RIGHT)
	
	items[tag_name] = item
	
	return item

func GetParentItem(tag_name: StringName) -> TreeItem:
	var dot: int = tag_name.rfind(".")
	var parent_path: StringName = &""
	
	if dot >= 0:
		parent_path = StringName(tag_name.substr(0, dot))
	
	return items.get(parent_path, items.get(&""))

func CheckItem(tag_name: StringName, checked: bool = false) -> void:
	items[tag_name].set_checked(0, checked)
