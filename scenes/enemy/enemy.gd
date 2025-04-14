extends Area2D

##################################################
const ROTATE_SPEED: float = 0.5
# 회전 속도

var fan_shaped_vision_node: Node2D
# 시야를 담당하는 노드

##################################################
func _ready() -> void:
	fan_shaped_vision_node = $FanShapedVision
	# 시야를 담당하는 노드 설정
	
	fan_shaped_vision_node.rotation = randf_range(0, 2 * PI)
	# 시작 시 무작위 방향으로 시야 회전 (0 ~ 2π 라디안)

##################################################
func _process(delta: float) -> void:
	fan_shaped_vision_node.rotate(ROTATE_SPEED * delta)
	# 매 프레임마다 시야를 일정 속도로 회전
