extends Node2D
class_name BlocksBuilder

signal block_placed(price: int, block: Block, fail: bool)

@export var joint_scene: PackedScene

@onready var joints_stacks: Node2D = $Joints
@onready var blocks_parent: Node = $Blocks

func on_place_block(from: MovingBlock) -> void:
	if not from.has_overlapping_bodies():
		block_placed.emit(0, null, true)
		return
		
	var position = from.global_position	
	var target: Block = from.get_overlapping_bodies()[0]
	var intersect_points := get_intersection(from, target)
	
	var new_block: Block =  from.block_resource.block_scene.instantiate()
	new_block.global_position = from.global_position
	
	var state_age: int = clamp(State.age, 0, State.MAX_AGE)
	var current_color := State.AGES_COLOR[state_age]
	var next_color := State.AGES_COLOR[(State.age + 1) if State.age < State.MAX_AGE else state_age]
	var color = current_color.lerp(next_color, State.get_age_progression())
	# new_block.color = State.AGES_COLOR[State.age]
	new_block.color = color
	
	blocks_parent.add_child(new_block)
	
	for point: Vector2 in intersect_points:
		var joint: PinJoint2D = joint_scene.instantiate()
		joint.global_position = point
		joint.node_a = target.get_path()
		joint.node_b = new_block.get_path()
		joints_stacks.add_child(joint)
		
	from.queue_free()
	block_placed.emit(from.block_resource.price, new_block, false)


func get_intersection(moving: MovingBlock, block: Block) -> PackedVector2Array:
	var moving_transform = moving.get_global_shape_transform()
	var block_transform = block.get_global_shape_transform()
	
	var collision := moving.shape.collide_and_get_contacts(
		moving_transform,
		block.shape,
		block_transform
	)
	
	return collision
