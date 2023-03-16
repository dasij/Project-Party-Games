extends Node2D
class_name BoardPlayer

signal do_action
signal changed_hp

@onready var camera: Camera2D = $Camera2D

@export var nick: String = ""
@export var speed := 200

var actual_tile: Tile = null : set = set_actual_tile
var deck := Deck.new()
var score := Score.new()
var max_hp := 30
var hp := max_hp : set = set_hp
var dead = false
var initial_scale = self.scale
# TODO:
# find a way to organize this if necessary
# I don't know if it is a good ideia to the player have the graph
# reference inside it. Maybe we should do this with an autoload event?
var graph = null


func set_hp(new_hp: int) -> void:
	if new_hp <= 0:
		hp = 0
		await self.die()
	elif new_hp >= max_hp:
		hp = max_hp
	else:
		hp = new_hp
	emit_signal("changed_hp", hp)


func get_camera() -> Camera2D:
	return camera


func set_actual_tile(new_tile: Tile) -> void:
	if actual_tile == null:
		self.position = new_tile.position
		actual_tile = new_tile
	elif new_tile == null:
		actual_tile = actual_tile
	else:
		actual_tile = new_tile


func move() -> void:
	var next_tile = await actual_tile.get_next_tile()
	await move_to_tile(next_tile)


func move_to_tile(new_tile: Tile) -> void:
	var path = self.graph.get_path_node(actual_tile, new_tile) as Path2D
	if path == null:
		await teleport_to_tile(new_tile)
		return
	
	var curve = path.curve.tessellate()

	for point in curve:
		var distance := self.position.distance_to(point)
		var duration := distance / self.speed
		var tweener = create_tween()
		tweener.tween_property(
			self, "position", point, duration
		)
		await tweener.finished
	set_actual_tile(new_tile)


func teleport_to_tile(new_tile: Tile) -> void:
	await animate_scale_down()
	self.position = new_tile.position
	self.actual_tile = new_tile
	await animate_restore()


func play_pre_turn(board: Board) -> void:
	await self.actual_tile.play_pre_turn_effect(board, self)


func play_turn(board: Board) -> void:
	for card in deck.get_hand():
		if self.dead:
			break
		await self.do_action
		await card.play_effect(board, self)
	deck.reset_hand()


func die() -> void:
	self.dead = true
	var nearest_graveyard = self.graph.bfs(actual_tile, func(node): return Tile.is_graveyard(node))
	await teleport_to_tile(nearest_graveyard)


func restore() -> void:
	self.hp = max_hp
	self.dead = false
	await animate_scale()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("confirm"):
		emit_signal("do_action")


func animate_scale_down() -> void:
	var tweener = create_tween()
	tweener.tween_property(self, "scale", Vector2.ZERO, 0.5)
	await tweener.finished


func animate_restore() -> void:
	var tweener = create_tween()
	tweener.tween_property(self, "scale", initial_scale, 0.5)
	await tweener.finished


func animate_scale() -> void:
	var tweener = create_tween()
	tweener.tween_property(self, "scale", scale * 2, 0.5)
	tweener.tween_property(self, "scale", scale, 0.5)
	await tweener.finished


func animate_rotation() -> void:
	var tweener = create_tween()
	tweener.tween_property(
		self, "rotation_degrees", 360, 1
	).as_relative()
	await tweener.finished
