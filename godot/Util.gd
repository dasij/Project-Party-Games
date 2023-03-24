class_name Util

# File with util functions


## Generate a random number between initial and final values
## both values are inclusive
static func randi_from_range(initial: int, final: int) -> int:
	return (randi() % (final - initial + 1)) + initial

static func array_get_random(array: Array) -> Variant:
	var idx = randi() % array.size()
	return array[idx]

static func array_get(array: Array, idx: int):
	if idx < array.size():
		return array[idx]
	else:
		return null


static func delete_children(node):
	if node != null:
		for n in node.get_children():
			node.remove_child(n)
			n.queue_free()


static func delete_child(node: Node, idx: int):
	var child = node.get_child(idx)
	node.remove_child(child)
	child.queue_free()


static func find_and_remove(arr: Array, item, from := 0):
	var idx = arr.find(item, from)
	if idx != -1:
		arr.pop_at(idx)
	return idx
