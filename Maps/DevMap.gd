@tool
extends Node2D

@export var tag_container: TagContainer

func _ready() -> void:
	TagManager.AddTag(&"State.Debuff.Poison")
