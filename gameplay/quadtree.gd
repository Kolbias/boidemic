class_name Quadtree extends Node

var boundary : Rect2
var node = null

var northWest : Quadtree
var northEast : Quadtree
var southWest : Quadtree
var southEast : Quadtree
var divided = false

func _init(_boundary : Rect2):
	boundary = _boundary

func insert(_node : Node2D):
	if !boundary.has_point(_node.position):
		return
	
	if divided:
		northWest.insert(_node)
		northEast.insert(_node)
		southWest.insert(_node)
		southEast.insert(_node)
		return
	
	if node == null:
		node = _node
	else:
		if !divided:
			subdivide()
		
		northWest.insert(node)
		northEast.insert(node)
		southWest.insert(node)
		southEast.insert(node)
		northWest.insert(_node)
		northEast.insert(_node)
		southWest.insert(_node)
		southEast.insert(_node)
		node = null

func subdivide():
	var y : float = boundary.size.y / 2
	var x : float = boundary.size.x / 2
	northWest = Quadtree.new(Rect2(boundary.position.x, boundary.position.y, x, y))
	northEast = Quadtree.new(Rect2(boundary.position.x + x, boundary.position.y, x, y))
	southWest = Quadtree.new(Rect2(boundary.position.x, boundary.position.y + y, x, y))
	southEast = Quadtree.new(Rect2(boundary.position.x + x, boundary.position.y + y, x, y))
	divided = true

func _to_string():
	var desc = "This quadtree contains "
	if node == null:
		desc += "no points"
	else:
		desc += "a point at %s"
		desc = desc % node
	if divided:
		desc += " and subtrees \n %s \n %s \n %s \n %s"
		desc = desc % [northWest, northEast, southWest, southEast]
	return desc

func queryRect(area : Rect2):
	var pointsInRect = []
	if !boundary.intersects(area):
		return pointsInRect
	
	if node != null:
		pointsInRect.append(node)
	
	if northWest == null:
		return pointsInRect
	
	for point in northWest.queryRect(area):
		pointsInRect.append(point)
	for point in northEast.queryRect(area):
		pointsInRect.append(point)
	for point in southWest.queryRect(area):
		pointsInRect.append(point)
	for point in southEast.queryRect(area):
		pointsInRect.append(point)
	
	return pointsInRect
