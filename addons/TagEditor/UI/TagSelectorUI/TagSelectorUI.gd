@tool
class_name TagSelectorUI extends Tree

signal TagsUpdated

var root: TreeItem
var items: Dictionary[StringName, TreeItem]
var selected_tag_names: Array[StringName]

func _init() -> void:
	TagManager.TagsUpdated.connect(Update)
	
	item_edited.connect(ItemEdited)
	
	hide_root = true
	columns = 2
	
	set_column_expand(0, false)
	set_column_custom_minimum_width(0, 30)
	set_column_expand(1, true)
	
	Update()

func Update() -> void:
	clear()
	items.clear()
	
	root = create_item()
	
	for tag_name in TagManager.tag_database.keys():
		FindOrCreateItem(tag_name)

func FindOrCreateItem(tag_name: StringName) -> TreeItem:
	if items.has(tag_name):
		return items[tag_name]
	else:
		if tag_name.find(".") == -1:
			var new_item: TreeItem = CreateItem(tag_name)
			
			return new_item
		else:
			var parent_name: String = tag_name.left(tag_name.rfind("."))
			var part_name: String = tag_name.right(tag_name.length() - tag_name.rfind(".") - 1)
			var parent: TreeItem = FindOrCreateItem(parent_name)
			var new_item: TreeItem = CreateItem(tag_name, parent)
			
			return new_item

func CreateItem(tag_name: StringName, parent: TreeItem = root) -> TreeItem:
	var new_item: TreeItem = create_item(parent)
	
	new_item.set_cell_mode(0, TreeItem.CELL_MODE_CHECK)
	new_item.set_editable(0, true)
	new_item.set_cell_mode(1, TreeItem.CELL_MODE_STRING)
	
	var part_name: String = tag_name.right(tag_name.length() - tag_name.rfind(".") - 1)
	
	new_item.set_text(1, part_name)
	new_item.set_metadata(1, tag_name)
	
	items[tag_name] = new_item
	
	return new_item

func CheckItem(tag_name: StringName, checked: bool = true) -> void:
	items[tag_name].set_checked(0, checked)

func ItemEdited() -> void:
	var item: TreeItem = get_edited()
	var tag_name: StringName = item.get_metadata(1)
	
	if item.is_checked(0):
		CheckItem(tag_name)
		selected_tag_names.append(tag_name)
	else:
		CheckItem(tag_name, false)
		selected_tag_names.erase(tag_name)
	
	TagsUpdated.emit()
