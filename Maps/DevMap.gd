@tool
extends Node2D

@export var tag_container: TagContainer
@export var tag_container1: TagContainer

func _ready() -> void:
	print("devmap: " + str(tag_container))
