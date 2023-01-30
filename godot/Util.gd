extends Node
class_name Util

# File with util functions

## Generate a random number between initial and final values
## both values are inclusive
static func randi_from_range(initial: int, final: int) -> int:
	return (randi() % (final - initial + 1)) + initial

static func array_get(array: Array, idx: int):
	if idx < array.size():
		return array[idx]
	else:
		return null
