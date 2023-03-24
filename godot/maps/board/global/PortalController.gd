extends Node2D

enum State {
	INACTIVE,
	BLUE,
	ORANGE
}

var portal_info := {
	"tiles": [],
	"orange": null,
	"blue": null,
}


func add_portal(portal_tile: PortalTile):
	portal_info.tiles.append(portal_tile)


func set_portal(portal_tile: PortalTile):
	var n := Util.randi_from_range(1, 10)
	if n <= 5:
		set_blue(portal_tile)
		if get_orange() == null:
			set_orange(get_random_portal_diff_from(portal_tile))
	else:
		set_orange(portal_tile)
		if get_blue() == null:
			set_blue(get_random_portal_diff_from(portal_tile))


func get_random_portal_diff_from(portal_tile: PortalTile) -> PortalTile:
	var tiles = portal_info.tiles as Array[PortalTile]
	tiles = tiles.filter(func(tile): return tile != portal_tile)
	var idx = Util.randi_from_range(0, tiles.size() - 1)
	return tiles[idx]


func get_blue() -> PortalTile:
	return portal_info.blue


func set_blue(portal_tile: PortalTile):
	if portal_info.blue != null:
		portal_info.blue.state = State.INACTIVE
	portal_tile.state = State.BLUE
	portal_info.blue = portal_tile


func get_orange() -> PortalTile:
	return portal_info.orange


func set_orange(portal_tile: PortalTile) -> void:
	if portal_info.orange != null:
		portal_info.orange.state = State.INACTIVE
	portal_tile.state = State.ORANGE
	portal_info.orange = portal_tile
